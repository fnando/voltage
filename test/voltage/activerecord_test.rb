# frozen_string_literal: true

require "test_helper"

class ARCreateEventTest < Minitest::Test
  let(:user) { User.new(username: "johndoe") }

  test "triggers before event" do
    callable = Callable.new(:before_create)
    user.before(:create, &callable)
    callable.expect(:before_create, nil, [user])
    user.save!

    assert callable.verify
  end

  test "triggers event" do
    callable = Callable.new(:on_create)
    user.on(:create, &callable)
    callable.expect(:on_create, nil, [user])
    user.save!

    assert callable.verify
  end

  test "triggers after event" do
    callable = Callable.new(:after_create)
    user.after(:create, &callable)
    callable.expect(:after_create, nil, [user])
    user.save!

    assert callable.verify
  end

  test "does not trigger events when record is invalid" do
    user = User.new
    calls = []

    user
      .before(:create) { calls << :before }
      .on(:create) { calls << :on }
      .after(:create) { calls << :after }

    user.save

    assert_equal [], calls
  end
end

class ARValidationEventTest < Minitest::Test
  let(:user) { User.new(username: "johndoe") }

  test "triggers before event" do
    callable = Callable.new(:before_validation)
    user.before(:validation, &callable)
    callable.expect(:before_validation, nil, [user])
    user.save!

    assert callable.verify
  end

  test "triggers after event" do
    callable = Callable.new(:after_validation)
    user.after(:validation, &callable)
    callable.expect(:after_validation, nil, [user])
    user.save!

    assert callable.verify
  end

  test "triggers validation event when record is invalid" do
    callable = Callable.new(:on_validation)
    user.username = nil
    user.on(:validation, &callable)

    callable.expect(:on_validation, nil, [user])
    user.save

    assert callable.verify
  end

  test "skips validation event when record is valid" do
    calls = []
    user.on(:validation) { calls << :on }
    user.save!

    assert_equal [], calls
  end
end

class ARUpdateEvent < Minitest::Test
  let(:user) { User.create!(username: "johndoe") }

  test "triggers before event" do
    callable = Callable.new(:before_update)
    user.before(:update, &callable)

    callable.expect(:before_update, nil, [user])
    user.update!(username: "johnd")

    assert callable.verify
  end

  test "triggers event" do
    callable = Callable.new(:on_update)
    user.on(:update, &callable)

    callable.expect(:on_update, nil, [user])
    user.update!(username: "johnd")

    assert callable.verify
  end

  test "triggers after event" do
    callable = Callable.new(:after_update)
    user.after(:update, &callable)

    callable.expect(:after_update, nil, [user])
    user.update!(username: "johnd")

    assert callable.verify
  end

  test "does not trigger events when record is invalid" do
    user.username = nil
    calls = []

    user
      .before(:update) { calls << :before }
      .on(:update) { calls << :on }
      .after(:update) { calls << :after }

    user.save

    assert_equal [], calls
  end
end

class ARRemoveEvent < Minitest::Test
  let(:user) { User.create!(username: "johndoe") }

  test "triggers before event" do
    callable = Callable.new(:before_remove)
    user.before(:remove, &callable)

    callable.expect(:before_remove, nil, [user])
    user.destroy

    assert callable.verify
  end

  test "triggers event" do
    callable = Callable.new(:on_remove)
    user.on(:remove, &callable)

    callable.expect(:on_remove, nil, [user])
    user.destroy

    assert callable.verify
  end

  test "triggers after event" do
    callable = Callable.new(:after_remove)
    user.after(:remove, &callable)

    callable.expect(:after_remove, nil, [user])
    user.destroy

    assert callable.verify
  end
end
