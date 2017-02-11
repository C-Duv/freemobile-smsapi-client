freemobile-smsapi-client
========================

API client for the Free Mobile SMS notification service

Theses clients send SMS notifications via [Free Mobile](http://mobile.free.fr) mobile broadband company native SMS-notification API.
This service can only send SMS to line's owner: it cannot be used to send SMS to any mobile number, group or massive spam.

Shell Client
------------

### Possible usages:

```
send-notification.sh "All your base are belong to us"
```

```
uptime | send-notification.sh
```

See `send-notification.sh -h`.

### Configuration :

Script can be configured 
Edit `send-notification.sh` and set the following variables:
* `USER_LOGIN`: The login to use the API.
* `API_KEY`: The secret key associated to `USER_LOGIN`.
* `MESSAGE_HEADER` (Optional): Will be prepended to all the messages.
* `MESSAGE_FOOTER` (Optional): Will be appended to all the messages.
* `NEWLINE_CHAR` (Optional): Char to use to create a new line (it depends on
  receiving terminal).


PHP Client
----------

*Soon*