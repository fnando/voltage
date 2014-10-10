# Signal

[![Code Climate](https://codeclimate.com/github/fnando/signal.png)](https://codeclimate.com/github/fnando/signal)

A simple observer implementation on POROs (Plain Old Ruby Object) and ActiveRecord objects.

## Installation

Add this line to your application's Gemfile:

    gem "signal"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install signal

## Usage

You can use Signal with PORO (Plain Old Ruby Object) and ActiveRecord.

### Plain Ruby

All you have to do is including the `Signal` module. Then you can add listeners and trigger events.

```ruby
class Status
  include Signal

  def ready!
    emit(:ready)
  end
end

status = Status.new
status.before(:ready) { puts "Before the ready event!" }
status.on(:ready) { puts "I'm ready!" }
status.after(:ready) { puts "After the ready event!" }
status.ready!
#=> Before the ready event!
#=> I'm ready!
#=> After the ready event!
```

You can also pass objects that implement methods like `before_*`, `on_*` and `after_*`.

```ruby
class MyListener
  def before_ready
    puts "Before the ready event!"
  end

  def on_ready
    puts "I'm ready!"
  end

  def after_ready
    puts "After the ready event!"
  end
end

status = Status.new
status.listeners << MyListener.new
status.ready!
#=> Before the ready event!
#=> I'm ready!
#=> After the ready event!
```

Blocks are executed in the context of the observable object.

```ruby
class Contact
  include Signal

  attr_reader :name, :email

  def initialize(name, email)
    @name, @email = name, email
  end

  def output!
    emit(:output)
  end
end

contact = Contact.new("John Doe", "john@example.org")
contact.on(:output) { puts name, email }
contact.output!
#=> John Doe
#=> john@example.org
```

You can provide arguments while emitting a signal:

```ruby
class Arguments
  include Signal
end

class MyListener
  def on_args(a, b)
    puts a, b
  end
end

args = Arguments.new
args.on(:args) {|a, b| puts a, b }
args.listeners << MyListener.new
args.emit(:args, 1, 2)
```

### ActiveRecord

You can use Signal with ActiveRecord, which will give you some default events like `:create`, `:update`, `:remove` and `:validation`.

```ruby
class Thing < ActiveRecord::Base
  include Signal::ActiveRecord

  validates_presence_of :name
end

thing = Thing.new(:name => "Stuff")
thing.on(:create) {|thing| puts thing.updated_at, thing.name }
thing.on(:update) {|thing| puts thing.updated_at, thing.name }
thing.on(:remove) {|thing| puts thing.destroyed? }
thing.on(:validation) {|thing| p thing.errors.full_messages }

thing.save!
#=> 2013-01-26 10:32:39 -0200
#=> Stuff

thing.update_attributes(:name => "Updated stuff")
#=> 2013-01-26 10:33:11 -0200
#=> Updated stuff

thing.update_attributes(:name => nil)
#=> ["Name can't be blank"]

thing.destroy
#=> true
```

These are the available events:

* `before(:create)`: triggered before creating the record (record is valid).
* `on(:create)`: triggered after `before(:create)` event.
* `after(:create)`: triggered after the `on(:create)` event.
* `before(:update)`: triggered before updating the record (record is valid).
* `on(:update)`: triggered when the `before(:update)` event.
* `after(:update)`: triggered after the `on(:update)` event.
* `before(:remove)`: triggered before removing the record.
* `on(:remove)`: triggered after the `before(:remove)`.
* `after(:remove)`: triggered after the `on(:remove)` event.
* `before(:validation)`: triggered before validating record.
* `on(:validation)`: triggered when record is invalid.
* `after(:validation)`: triggered after validating record.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Nando Vieira

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
