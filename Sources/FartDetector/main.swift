import SwiftyGPIO
import Foundation

let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi3)
var gp = gpios[.P2]!


