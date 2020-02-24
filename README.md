# Signal

[![Build Status](https://travis-ci.org/fnando/signal.svg?branch=master)](https://travis-ci.org/fnando/signal)
[![Code Climate](https://codeclimate.com/github/fnando/signal/badges/gpa.svg)](https://codeclimate.com/github/fnando/signal)
[![Test Coverage](https://codeclimate.com/github/fnando/signal/badges/coverage.svg)](https://codeclimate.com/github/fnando/signal)

A simple observer implementation on POROs (Plain Old Ruby Object) and
ActiveRecord objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'signal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install signal

## Usage

You can use Signal with PORO (Plain Old Ruby Object) and ActiveRecord.

### Plain Ruby

All you have to do is including the `Signal` module. Then you can add listeners
and trigger events.

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

You can also pass objects that implement methods like `before_*`, `on_*` and
`after_*`.

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

Status.new
  .add_listener(MyListener.new)
  .ready!
#=> Before the ready event!
#=> I'm ready!
#=> After the ready event!
```

Executed blocks don't switch context. You always have to emit the object you're
interested in. The follow example uses `emit(:output, self)` to send the
`Contact` instance to all listeners.

```ruby
class Contact
  include Signal

  attr_reader :name, :email

  def initialize(name, email)
    @name, @email = name, email
  end

  def output!
    emit(:output, self)
  end
end

contact = Contact.new('John Doe', 'john@example.org')
contact.on(:output) {|contact| puts contact.name, contact.email }
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

Arguments.new
  .on(:args) {|a, b| puts a, b }
  .add_listener(MyListener.new)
  .emit(:args, 1, 2)
```

### ActiveRecord

You can use Signal with ActiveRecord, which will give you some default events
like `:create`, `:update`, `:remove` and `:validation`.

```ruby
class Thing < ActiveRecord::Base
  include Signal.active_record

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

- `before(:create)`: triggered before creating the record (record is valid).
- `on(:create)`: triggered after `before(:create)` event.
- `after(:create)`: triggered after the `on(:create)` event.
- `before(:update)`: triggered before updating the record (record is valid).
- `on(:update)`: triggered when the `before(:update)` event.
- `after(:update)`: triggered after the `on(:update)` event.
- `before(:remove)`: triggered before removing the record.
- `on(:remove)`: triggered after the `before(:remove)`.
- `after(:remove)`: triggered after the `on(:remove)` event.
- `before(:validation)`: triggered before validating record.
- `on(:validation)`: triggered when record is invalid.
- `after(:validation)`: triggered after validating record.

### Inside Rails

Although there's no special code for Rails, here's just an example of how you
can use it:

```ruby
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    Signup.new(@user)
      .on(:success) { redirect_to login_path, notice: 'Welcome to MyApp!' }
      .on(:failure) { render :new }
      .call
  end
end
```

If you're using plain ActiveRecord, just do something like the following:

```ruby
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user
      .on(:create) { redirect_to login_path, notice: 'Welcome to MyApp!' }
      .on(:validation) { render :new }
      .save
  end
end
```

### Signal::Call

You can include `Signal.call` instead, so you can have a common interface for
your observable object. This will add the `.call()` method to the target class,
which will delegate attributes to the observable's `initialize` method and call
its `call` method.

```ruby
class Contact
  include Signal.call

  attr_reader :name, :email

  def initialize(name, email)
    @name, @email = name, email
  end

  def call
    emit(:output, self)
  end
end

Contact.call('John', 'john@example.com') do |o|
  o.on(:output) {|contact| puts contact }
end
```

Notice that you don't have to explicit call the instance's `call` method;
`Contact.call` will initialize the object with all the provided parameters and
call `Contact#call` after the block has been executed.

### Testing

`Signal::Mock` can be helpful for most test situations where you don't want to
bring other mock libraries.

```ruby
require "signal/mock"

class SomeTest < Minitest::Test
  def test_some_test
    mock = Signal::Mock.new

    # Using listener
    sum = Sum.new
    sum.add_listener(mock)

    # Calling `mock.on(event_name)` is required because
    # the handler doesn't receive the event name, just the
    # arguments.
    sum = Sum.new
    sum.on(:result, &mock.on(:result))

    # Using with Signal.call
    Sum.call(1, 2, &mock)

    assert mock.received?(:result)
    assert mock.received?(:result, times: 1)
    assert mock.received?(:result, with: [3])
    assert mock.received?(:result, with: ->(result) { result == 3 } )
  end
end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Nando Vieira

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
