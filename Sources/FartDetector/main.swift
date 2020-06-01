import Foundation
import SwiftyGPIO

let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi3)

var trigger = GPIOName.P4

gpios[trigger]!.direction = .IN

func setPin(pin: GPIOName, isOn: Bool) {
	if isOn {
		gpios[pin]!.direction = .OUT
		gpios[pin]!.value = 0
	} else {
		gpios[pin]!.direction = .IN
	}
}

func setDAC(bitwise: Int) {
	setPin(pin: .P17, isOn: bitwise & 1 == 1)
	setPin(pin: .P18, isOn: bitwise & 2 == 2)
	setPin(pin: .P22, isOn: bitwise & 4 == 4)
	setPin(pin: .P23, isOn: bitwise & 8 == 8)
}

func calibrate(trace: Bool = false, sleepTime: Double = 0) -> Int {
	var result = -1
	
	for i in 0..<16 {
		setDAC(bitwise: i)
		if trace {
			print(String(format: "%b", i))
		}
		
		usleep(useconds_t(sleepTime))
		
		if gpios[trigger]!.value == 0 {
			result = i
			break
		}
	}
	
	return result
}

let minute = 1000000
let second = 100000

while true {
	let freshAir = calibrate(trace: true, sleepTime: Double(5 * second))
	
	if freshAir != -1 {
		print("Calibrated to \(freshAir)")
		
		let startTime = Date()
		
		print("Waiting for fart...")
		
		while gpios[trigger]!.value == 0 && ((-Int(startTime.timeIntervalSinceNow)) < 120) {
			usleep(useconds_t(1 * second))
			
			if (-Int(startTime.timeIntervalSinceNow)) < 120 {
				let fart = calibrate(sleepTime: Double(1 * second))
				
				if fart > freshAir || fart == -1 {
					if fart >= 0 && fart < 5 {
						print("Huh only level", fart, "detected, call that a fart?")
					} else if fart >= 5 && fart < 10 {
						print("Fart level", fart, "detected!")
					} else if fart >= 10 && fart < 15 {
						print("DANGER! Fart level", fart, "detected!")
					} else if fart == -1 {
						print("GAS GAS GAS! FART LEVEL", "EXTREME", "DETECTED! EVACUATE EVACUATE EVACUATE!")
					}
				}
			}
			
		}
		
	}
}

