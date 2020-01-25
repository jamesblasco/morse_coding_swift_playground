//
//  ToneAudioUnit.swift
//  Morse
//
//  Created by Jaime on 14/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//
//
//  File based on the following one:
//  https://gist.github.com/hotpaw2/630a466cc830e3d129b9
//  Created by Ronald Nicholson  rhn@nicholson.com  on 2/20/2016.
//    revised 2016-Sep-08 for Swift 3
//  http://www.nicholson.com/rhn/
//  Copyright © 2016 Ronald H Nicholson, Jr. All rights reserved.
//  Distribution: BSD 2-clause license
//
//


import Foundation
import AudioUnit
import AVFoundation

public enum Tone: Double {
//    case f1 = 440.0
//    case f2 = 880.0
//    case f3 = 1320.0
//    case f4 = 1760.0
    
    case B7 = 3951.07
    case A7 = 3520.00
    case G7 = 3135.96
    case F7 = 2793.83
    case E7 = 2637.02
    case D7 = 2349.32
    case C7 = 2093.00
    case B6 = 1975.53
    case A6 = 1760.00
    case G6 = 1567.98
    case F6 = 1396.91
    case E6 = 1318.51
    case D6 = 1174.66
    case C6 = 1046.50
    case B5 = 987.767
    case A5 = 880.000
    case G5 = 783.991
    case F5 = 698.456
    case E5 = 659.255
    case D5 = 587.330
    case C5 = 523.251
    case B4 = 493.883
    case A4 = 440.000
    case G4 = 391.995
    case F4 = 349.228
    case E4 = 329.628
    case D4 = 293.665
    case C4 = 261.626
    case B3 = 246.942
    case A3 = 220.000
    case G3 = 195.998
    case F3 = 174.614
    case E3 = 164.814
    case D3 = 146.832
    case C3 = 130.813
    case B2 = 123.471
    case A2 = 110.000
    case G2 = 97.9989
    case F2 = 87.3071
    case E2 = 82.4069
    case D2 = 73.4162
    case C2 = 65.4064
    case B1 = 61.7354
    case A1 = 55.0000
    case G1 = 48.9995
    case F1 = 43.6536
    case E1 = 41.2035
    case D1 = 36.7081
    case C1 = 32.7032
    case B0 = 30.8677
    case A0 = 27.5000
}



final public class ToneAudioUnit: NSObject {
    static public var shared: ToneAudioUnit = { return ToneAudioUnit() }()
    
    // Placeholder for RemoteIO Audio Unit
    var audioUnit: AUAudioUnit! = nil
    
    public var isSessionActive     = false             // AVAudioSession active flag
    public var isAudioRunning = false             // RemoteIO Audio Unit running flag
    public var isSpeakerEnabled = false
    
    var sampleRate : Double = 22100.0    // typical audio sample rate
    var frequency  =  880.0              // default frequency of tone:   'A' above Concert A
    var volume  =  16383.0              // default volume of tone:      half full scale
    
    var toneCount : Int32 = 0       // number of samples of tone to play.  0 for silence
    
    private var phY =     0.0       // save phase of sine wave to prevent clicking
    private var interrupted = false     // for restart from audio interruption notification

    public func play(tone: Tone, forDuration time: Double? = nil) {
        if isAudioRunning { stop() }
        enableSpeakerIfNedded()
        isAudioRunning = true
        frequency = tone.rawValue
        toneCount = time == nil ? Int32.max : Int32(time! * sampleRate)
    }

    
//    func startToneForDuration(time : Double) {
//        if isAudioRunning { stop() }
//        if !isSpeakerEnabled { enableSpeaker() }
//        
//        toneCount = Int32(time * sampleRate)
//    }
    
    public func removeSpeaker() {
        audioUnit.stopHardware()
        isSpeakerEnabled = false
    }
    
    
    public func stop() {
        if (isAudioRunning) {
            isAudioRunning = false
            toneCount = 0
        }
    }
    
    
    
    /**
        Set Frequency
     
     - Attention:  Audio frequencies below 500 Hz may be
     hard to hear from a tiny iPhone speaker.
   
    */
    public func setFrequency(freq : Double) {
        frequency = freq
    }
    
    /**
      Set Tone Volume
     
     - Attention:  Value from 0.0 to 1.0
     
     */
    public func setToneVolume(vol : Double) {
        volume = vol * 32766.0
    }
    
    public func setToneTime(t : Double) {
        toneCount = Int32(t * sampleRate)
    }
    
    public func enableSpeakerIfNedded() {
        
        
        if isAudioRunning { return }    // return if RemoteIO is already running
        if (isSessionActive == false) {
            
            do {        // set and activate Audio Session
                
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(AVAudioSession.Category.soloAmbient,
                                             mode: .default, options: .defaultToSpeaker)
               
                var preferredIOBufferDuration = 4.0 * 0.0058      // 5.8 milliseconds = 256 samples
                let hwSRate = audioSession.sampleRate           // get native hardware rate
                if hwSRate == 48000.0 { sampleRate = 48000.0 }  // set session to hardware rate
                if hwSRate == 48000.0 { preferredIOBufferDuration = 4.0 * 0.0053 }
                let desiredSampleRate = sampleRate
                try audioSession.setPreferredSampleRate(desiredSampleRate)
                try audioSession.setPreferredIOBufferDuration(preferredIOBufferDuration)
                
                NotificationCenter.default.addObserver(
                    forName: AVAudioSession.interruptionNotification,
                    object: nil,
                    queue: nil,
                    using: myAudioSessionInterruptionHandler )
                
                try audioSession.setActive(true)
                isSessionActive = true
            } catch /* let error as NSError */ {
                // handle error (audio system broken?)
            }
        }
        
        if (!isSpeakerEnabled) {
            do {        // not running, so start hardware
                
                let audioComponentDescription = AudioComponentDescription(
                    componentType: kAudioUnitType_Output,
                    componentSubType: kAudioUnitSubType_RemoteIO,
                    componentManufacturer: kAudioUnitManufacturer_Apple,
                    componentFlags: 0,
                    componentFlagsMask: 0 )
                
                if (audioUnit == nil) {
                    
                    try audioUnit = AUAudioUnit(componentDescription: audioComponentDescription)
                    
                    let bus0 = audioUnit.inputBusses[0]
                    
                    let audioFormat = AVAudioFormat(
                        commonFormat: AVAudioCommonFormat.pcmFormatInt16,   // short int samples
                        sampleRate: Double(sampleRate),
                        channels:AVAudioChannelCount(2),
                        interleaved: true )                                 // interleaved stereo
                    
                    try bus0.setFormat(audioFormat!)  //      for speaker bus
                    
                    audioUnit.outputProvider = { (    //  AURenderPullInputBlock?
                        actionFlags,
                        timestamp,
                        frameCount,
                        inputBusNumber,
                        inputDataList ) -> AUAudioUnitStatus in
                        
                        self.fillSpeakerBuffer(inputDataList: inputDataList,
                                               frameCount: frameCount)
                        return(0)
                    }
                }
                
                audioUnit.isOutputEnabled = true
                toneCount = 0
                
                try audioUnit.allocateRenderResources()  //  v2 AudioUnitInitialize()
                try audioUnit.startHardware()            //  v2 AudioOutputUnitStart()
                isAudioRunning = true
                isSpeakerEnabled = true
                
            } catch /* let error as NSError */ {
                // handleError(error, functionName: "AUAudioUnit failed")
                // or assert(false)
            }
        }
            
        
    }
    
    // helper functions
    
    private func fillSpeakerBuffer(     // process RemoteIO Buffer for output
        inputDataList : UnsafeMutablePointer<AudioBufferList>,
        frameCount : UInt32 )
    {
        let inputDataPtr = UnsafeMutableAudioBufferListPointer(inputDataList)
        let nBuffers = inputDataPtr.count
        if (nBuffers > 0) {
            
            let mBuffers : AudioBuffer = inputDataPtr[0]
            let count = Int(frameCount)
            
            // Speaker Output == play tone at frequency f0
            if (   self.volume > 0)
                && (self.toneCount > 0 )
            {
                // audioStalled = false
                
                var v  = self.volume ; if v > 32767 { v = 32767 }
                let sz = Int(mBuffers.mDataByteSize)
                
                var a  = self.phY        // capture from object for use inside block
                let d  = 2.0 * .pi * self.frequency / self.sampleRate     // phase delta
                
                let bufferPointer = UnsafeMutableRawPointer(mBuffers.mData)
                if var bptr = bufferPointer {
                    for i in 0..<(count) {
                        let u  = sin(a)             // create a sinewave
                        a += d ; if (a > 2.0 * .pi) { a -= 2.0 * .pi }
                        let x = Int16(v * u + 0.5)      // scale & round
                        
                        if (i < (sz / 2)) {
                            bptr.assumingMemoryBound(to: Int16.self).pointee = x
                            bptr += 2   // increment by 2 bytes for next Int16 item
                            bptr.assumingMemoryBound(to: Int16.self).pointee = x
                            bptr += 2   // stereo, so fill both Left & Right channels
                        }
                    }
                }
                
                self.phY        =   a                   // save sinewave phase
                self.toneCount  -=  Int32(frameCount)   // decrement time remaining
            } else {
                // audioStalled = true
                memset(mBuffers.mData, 0, Int(mBuffers.mDataByteSize))  // silence
            }
        }
    }
    
    
    private func myAudioSessionInterruptionHandler( notification: Notification ) -> Void {
        let interuptionDict = notification.userInfo
        if let interuptionType = interuptionDict?[AVAudioSessionInterruptionTypeKey] {
            let interuptionVal = AVAudioSession.InterruptionType(
                rawValue: (interuptionType as AnyObject).uintValue )
            if (interuptionVal == AVAudioSession.InterruptionType.began) {
                if (isAudioRunning) {
                    audioUnit.stopHardware()
                    isAudioRunning = false
                    interrupted = true
                }
            }
        }
    }
}

//  end of the ToneOutputUnit class
