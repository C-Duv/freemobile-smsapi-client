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

### Configuration :

Edit `send-notification.sh` and set the following variables:

* `USER_LOGIN`
* `API_KEY`
* `MESSAGE_HEADER` (Optional)
* `MESSAGE_FOOTER` (Optional)

PHP Client
----------

*Soon*