// Copyright (c) 2015 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class IFTTT {

    static VERSION = [1, 0, 0];

    static TOO_MANY_VALUES_EXCEPTION = "IFTTT only supports up to 3 values per event";

    static API_URL = "https://maker.ifttt.com/trigger/%s/with/key/%s";

    _key = null;

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
        if(typeof firstArgument == "array") {
            if(firstArgument.len() > 3) {
                throw TOO_MANY_VALUES_EXCEPTION;
            }

            for(local i = 0; i < firstArgument.len(); i++) {
                local value = firstArgument[i];
                if(value != null) {
                    body["value" + (i + 1)] <- value;
                }
            }
        } else if(typeof firstArgument != "function"){
            body["value1"] <- firstArgument;
        }

        local request = http.post(url, headers, http.jsonencode(body));
        local requestCallback = _requestCallbackFactory(userCallback);
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
