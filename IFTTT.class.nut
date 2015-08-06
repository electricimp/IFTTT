// Copyright (c) 2015 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class IFTTT {
    // Library version
    static version = [1, 0, 0];

    // Errors
    static ERR_TOO_MANY_VALUES = "IFTTT only supports up to 3 values per event";

    static API_URL = "https://maker.ifttt.com/trigger/%s/with/key/%s";

    _key = null;    // User's secret key

    function constructor(key) {
        _key = key;
    }

    function sendEvent(eventName, ...) {
        local url = format(API_URL, eventName, _key);
        local headers = {
            "content-type": "application/json"
        };

        local userCallback = null;

        // If the last argument is a function, then it is the user-supplied callback
        if(vargv.len() > 0 && typeof vargv[vargv.len() - 1] == "function") {
            userCallback = vargv[vargv.len() - 1];
        }

        // Add optional parameters to body.  IFTTT currently limits these to 3.
        local body = {};
        local firstArgument = vargv[0];

        // If they passed an array:
        if(typeof firstArgument == "array") {
            // Make sure no more than 3 values were passed
            if(firstArgument.len() > 3) {
                throw ERR_TOO_MANY_VALUES;
            }

            // Add each of the non-null parameters
            for(local i = 0; i < firstArgument.len(); i++) {
                local value = firstArgument[i];
                if(value != null) {
                    body["value" + (i + 1)] <- value;
                }
            }
        } else if(typeof firstArgument != "function"){
            // If the passed anything else, sent it as value1
            body["value1"] <- firstArgument;
        }

        // Create the request
        local request = http.post(url, headers, http.jsonencode(body));
        // Build the callback
        local requestCallback = _requestCallbackFactory(userCallback);
        // Send the request + invoke callback on completion
        request.sendasync(requestCallback);
    }

    // -------------------- PRIVATE METHODS -------------------- //

    function _requestCallbackFactory(userCallback) {
        return function(response) {
            if(userCallback != null) {
                if(200 > response.statuscode || response.statuscode >= 300) {
                    imp.wakeup(0, function() {
                        userCallback(response.body, response);
                    });
                } else {
                    imp.wakeup(0, function() {
                        userCallback(null, response);
                    });
                }
            }
        }
    }
}
