freemobile-smsapi-client
========================

API client for the Free Mobile SMS notification service

Theses clients send SMS notifications via [Free Mobile](http://mobile.free.fr) mobile broadband company native SMS-notification API.
This service can only send SMS to line's owner: it cannot be used to send SMS to any mobile number, group or massive spam.

Shell Client
------------

### Possible usages:

```
send-notification.sh [options] "All your base are belong to us"
```

```
uptime | send-notification.sh [options]
```

See `send-notification.sh -h`.

### Configuration :

Script can be configured using the following variables:

* `USER_LOGIN`: The login to use the API.
* `API_KEY`: The secret key associated to `USER_LOGIN`.
* `MESSAGE_HEADER` (Optional): Will be prepended to all the messages.
* `MESSAGE_FOOTER` (Optional): Will be appended to all the messages.
* `NEWLINE_CHAR` (Optional): Char to use to create a new line (it depends on
  receiving terminal).

Theses can be directly changed in the `send-notification.sh` file or set in a 
separate configuration file named `.freemobile-smsapi` next to the script or in
the user's home directory. A given filepath can also be specify using the `-c`
script at runtime (`send-notification.sh -c foobar`).

Configuration load process is as follows:

# Uses what's in `send-notification.sh` file.
# If `-c` option is set, test given file existence and uses what's inside.
  Will not load any other configuration file (stops load process here).
# Checks if a `.freemobile-smsapi` file exists next to the script and uses
  what's inside. Will not load any other configuration file (stops load process
  here).
# Checks if a `.freemobile-smsapi` file exists in user's home directory
  (`${HOME}`) and uses what's inside. Will not load any other configuration file
  (stops load process here).


PHP Client
----------

*Soon*