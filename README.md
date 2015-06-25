# apartment-intercom-adapter
Live in an apartment with one of those intercoms that phones your phone?

Live in that apartment with more than one person?

This little sinatra app, along with a [Twilio][1] number, will simultaneously
phone all the numbers provided and connect with the first phone to pick up.

There's also a simple admin interface to update the phone numbers.

To get going:
```shell
$ git clone git://github.com/afontaine/apartment-intercom-adapter.git
$ rake
$ rackup
```

Deploy as you will. No DB required.

[1]: https://www.twilio.com/
