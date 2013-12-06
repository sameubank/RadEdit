var DEBUG_ENABLED = true
var TRACE_ENABLED = false

/**
 * Log values to the console, if it's available.
 */
var log = function(message, object) {
    if (DEBUG_ENABLED && window.console && console.log) {
        // Prefix the first argument (hopefully a string) with the marker.
        if (typeof object == 'undefined') {
            console.log(message)
        }
        else {
            console.log(message, object)
        }
    }
}

/**
 * Log the signature of a function call for debugging purposes.
 */
var trace = function(functionPath) {
    if (TRACE_ENABLED && window.console && console.log) {
        // Make an array from the arguments of the function that called this one.
        var array = [].slice.call(arguments.callee.caller.arguments, 0)
        // Add the function path as if it was the first argument.
        console.log('trace: ' + functionPath, array)
    }
}
