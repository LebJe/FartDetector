import SwiftyGPIO
import Foundation

let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi3)
var gp = gpios[.P2]!

gp.direction = .OUT

while true {
	gp.value = 1
	gp.value = 0
}
