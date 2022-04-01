//
//  Logger.swift
//  LLCommon
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import SwiftyBeaver

public class Logger: NSObject {
    public class func register() {
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        // use custom format and set console output to short time, log level & message
        console.format = "$DHH:mm:ss$d $L $M"
        // or use this for JSON output: console.format = "$J"

        // add the destinations to SwiftyBeaver
        SwiftyBeaver.addDestination(console)
        SwiftyBeaver.addDestination(file)

        SwiftyBeaver.verbose("not so important")  // prio 1, VERBOSE in silver
        SwiftyBeaver.debug("something to debug")  // prio 2, DEBUG in green
        SwiftyBeaver.info("a nice information")   // prio 3, INFO in blue
        SwiftyBeaver.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
        SwiftyBeaver.error("ouch, an error did occur!")  // prio 5, ERROR in red
    }

    public class func verbose(_ str: String) {
        SwiftyBeaver.verbose(str)
    }

    public class func debug(_ str: String) {
        SwiftyBeaver.debug(str)
    }

    public class func info(_ str: String) {
        SwiftyBeaver.info(str)
    }

    public class func warning(_ str: String) {
        SwiftyBeaver.warning(str)
    }

    public class func error(_ str: String) {
        SwiftyBeaver.error(str)
    }
}
