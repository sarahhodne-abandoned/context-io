ContextIO spec / roadmap
========================

These are things that will be included in the "Usage" section of the README
file. Think of this as a roadmap.

### Getting a list of messages

Once you have an `Account` object, you can get a list of messages as an array
of `Message` objects.

```ruby
account.messages
# => [#<ContextIO::Message to: 'me@example.com', ...>, ...]
```

You can also search for messages (see the documentation for
ContextIO::Message#find for the full list of attributes you can search for.

```ruby
account.messages(:subject => 'Hello, world!').first
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

