# IFTTT v1.0.0

[IFTTT](https://ifttt.com) (If This Then That) is a service that allows you to easily connect triggers to actions across a plethora of products and services. This class allows an Electric Imp agent to trigger events on the [IFTTT Maker Channel](https://ifttt.com/maker).

## Class Usage

The IFTTT class provides three methods to send events to your IFTTT Maker Channel: [with an eventName and no data](#sendeventeventname-callback), [with an eventName and a single peice of data](#sendeventeventname-value1-callback), and [with an eventName and an array containing up to three peices of data](#sendeventeventname-valuearray-callback).

### Constructor: IFTTT(*secretKey*)

Creates an object that can be used to trigger events.

To get a secret key, sign into your IFTTT account and then click "Connect" on the [Maker Channel page](https://ifttt.com/maker). You will then be directed to a page that contains your secret key. Copy just this key as a string into the constructor.

```squirrel
#require "IFTTT.class.nut:1.0.0"

// Replace this string with your secret key
ifttt <- IFTTT("<-- SECRET_KEY -->");
```

## Class methods

### sendEvent(*eventName, [callback]*)

Triggers an IFTTT event with no argument values.

*For details on callback construction, see [sendEvent(eventName, valueArray, [callback])](#sendeventeventname-valuearray-callback)).*

```squirrel
// Trigger an event with no values and a callback
ifttt.sendEvent("something_happened", function(err, response) {
    if(err) {
        server.error(err);
        return;
    }
    server.log("Success!!");
});
```

### sendEvent(*eventName, value1, [callback]*)

Triggers an IFTTT event with one argument value.

*For more details on the use of values and callback construction, see [sendEvent(eventName, valueArray, [callback])](#sendeventeventname-valuearray-callback)).

```squirrel
// Trigger an event with one value and a callback
ifttt.sendEvent("something_happened", "red", function(err, response) {
    if(err) {
        server.error(err);
        return;
    }

    server.log("Success!");
});
```

### sendEvent(*eventName, valueArray, [callback]*)

Triggers an IFTTT event with up to 3 argument values.

All events must have a name that is linked to a specific IFTTT recipe.

Events may also have up to 3 optional parameter values, named `value1`, `value2`, and `value3` that are passed through to the IFTTT recipe. These values can be placed in the *valueArray* parameter in the order that they should be received. To not use a particular value slot, leave it out of the array or set it to null (see example below). This method will throw an `IFTTT.ERR_TOO_MANY_VALUES` exception if more than 3 elements are placed in the *valueArray* array.

This method also optionally takes a callback that takes an *err* and a *response*. The *response* will always be the response object returned by [`httprequest.sendasync()`](https://electricimp.com/docs/api/httprequest/sendasync/) and *err* will be non-null on HTTP errors.

```squirrel
// Trigger an event with 3 parameters and a callback
// value1: red
// value2: **don't send**
// value3: banana
ifttt.sendEvent("something_happened", ["red", null, "banana"], function(err, response) {
    if(err) {
        server.error(err);
        return;
    }

    server.log("Success!");
});
```

# License

The IFTTT class is licensed under the [MIT License](https://github.com/electricimp/ifttt/tree/master/LICENSE).
