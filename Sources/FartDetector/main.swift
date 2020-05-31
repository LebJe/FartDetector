import Foundation
import SwiftyGPIO

let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi3)
var gp = gpios[.P1]!

gp.direction = .OUT

while true {
	gp.value = 1
	print("ON")
	sleep(2)
	gp.value = 0
	print("OFF")
	sleep(2)
}
