ContextIO spec / roadmap
========================

These are things that will be included in the "Usage" section of the README
file. Think of this as a roadmap.

### Authenticate

ContextIO uses [OAuth][oauth] for authentication, which you need to implement
in your app one way or another. Once you have the consumer key and secret, and
the oauth token and token secret, you can set up ContextIO like this:

```ruby
ContextIO.configure do |config|
  config.consumer_key = 'consumer key'
  config.consumer_secret = 'consumer secret'
  config.oauth_token = 'oauth token'
  config.oauth_token_secret = 'oauth token secret'
end
```

### Get an Account object

Once you're authenticated, you can get an `Account` object, which is what you
will be dealing with most of the time.

```ruby
account = ContextIO::Account.all.first
```

You can also find accounts matching a given email address.

```ruby
account = ContextIO::Account.find(:email => 'me@example.org').first
```

### Getting a list of messages

Once you have an `Account` object, you can get a list of messages as an array
of `Message` objects.

```ruby
account.messages.all
# => [#<ContextIO::Message to: 'me@example.com', ...>, ...]
```

You can also search for messages (see the documentation for
ContextIO::Message#find for the full list of attributes you can search for.

```ruby
account.messages.find(:subject => 'Hello, world!').first
# => #<ContextIO::Message subject: 'Hello, world!', ...>
```

### The Message object

`Message` objects contains information about that message.

```ruby
message = account.messages.first

message.subject
# => "Hello, world!"

message.from
# => "John Doe <john.doe@example.com>"

message.to
# => "me@example.com"

message.date
# => Thu Jan 05 23:30:22 +0100 2012

message.message_id
# => "abcdef0123456789"

message.email_message_id
# => "<20120105233022.abcdef0@mta1.mail.example.com>"

