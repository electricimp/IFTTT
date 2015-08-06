# IFTTT Library

[IFTTT](https://ifttt.com) (If This Then That) is a service that allows you to easily connect triggers to actions across a plethora of products and services. This class allows an Electric Imp agent to trigger events on the [IFTTT Maker Channel](https://ifttt.com/maker).

## Constructor: IFTTT(*secretKey*)

Creates an object that can be used to trigger events.

To get a secret key, sign into your IFTTT account and then click "Connect" on the [Maker Channel page](https://ifttt.com/maker). You will then be directed to a page that contains your secret key. Copy just this key as a string into the constructor.

### Usage

```squirrel
#require "IFTTT.class.nut:1.0.0"

// Replace this string with your secret key
local ifttt = IFTTT("<-- SECRET_KEY -->");
```

## sendEvent(*eventName, [callback]*)

Triggers an IFTTT event with no argument values.

*For details on callback construction, see [sendEvent(*eventName, value1, [callback]*)](#sendeventeventName-value1-callback).*

### Usage

```squirrel
// Trigger an event with no values and a callback
ifttt.trigger("something_happened", function(err, response) {
    if(err) {
        server.error(error);
        return;
    }
    server.log("Success!!");
});
```

## sendEvent(*eventName, value1, [callback]*)

Triggers an IFTTT event with one argument value.

For more details on the use of values and callback construction, see [sendEvent(*eventName, value1, [callback]*)](#sendeventeventName-value1-callback).

### Usage

```squirrel
// Trigger an event with one value and a callback
ifttt.trigger("something_happened", "red", function(err, response) {
    if(err) {
        server.error(error);
        return;
    }

    server.log("Success!");
});
```

## sendEvent(*eventName, values, [callback]*)

Triggers an IFTTT event with up to 3 argument values.

All events must have a name that is linked to a specific IFTTT recipe.

Events may also have up to 3 optional parameter values, named `value1`, `value2`, and `value3` that are passed through to the IFTTT recipe. Place these in the *values* array in the order that they should be received. To not use a particular value slot, leave it out of the array or set it to null. This method will throw an exception if more than 3 elements are placed in the array.

This method also optionally takes a callback that takes an *error* and a *response*. The *response* will always be the response object returned by [`httprequest.sendasync()`](https://electricimp.com/docs/api/httprequest/sendasync/) and *error* will be non-null on HTTP errors.

### Usage

```squirrel
// Trigger an event with 3 parameters and a callback
ifttt.trigger("something_happened", ["red", "Tuesday", "banana"], function(err, response) {
    if(err) {
        server.error(error);
        return;
    }

    server.log("Success!");
});
```

# License

The IFTTT class is licensed under the [MIT License](https://github.com/electricimp/ifttt/tree/master/LICENSE).
