require "spec_helper"

describe Signal::ActiveRecord do
  let(:callable) { Callable.new }
  let(:user) { User.new(:username => "johndoe") }

  context "create event" do
    it "triggers before event" do
      user.before(:create, &callable)
      callable.should_receive(:called).with(user)
      user.save!
    end

    it "triggers event" do
      user.on(:create, &callable)
      callable.should_receive(:called).with(user)
      user.save!
    end

    it "triggers after event" do
      user.after(:create, &callable)
      callable.should_receive(:called).with(user)
      user.save!
    end

    it "doesn't trigger on/after events when record is invalid" do
      user = User.new

      on_callable = Callable.new
      after_callable = Callable.new

      user
        .on(:create, &on_callable)
        .after(:create, &after_callable)

      on_callable.should_not_receive(:called)
      after_callable.should_not_receive(:called)

      user.save
    end
  end

  context "validation event" do
    it "triggers before event" do
      user.before(:validation, &callable)
      callable.should_receive(:called).with(user)
      user.save!
    end

    it "triggers after event" do
      user.after(:validation, &callable)
      callable.should_receive(:called).with(user)
      user.save!
    end

    it "triggers validation event when record is invalid" do
      user.username = nil
      user.on(:validation, &callable)
      callable.should_receive(:called).with(user)
      user.save
    end

    it "skips validation event when record is valid" do
      user.on(:validation, &callable)
      callable.should_not_receive(:called)
      user.save!
    end
  end

  context "update event" do
    let(:user) { User.create!(:username => "johndoe") }

    it "triggers before event" do
      user.before(:update, &callable)
      callable.should_receive(:called).with(user)
      user.update_attributes!(:username => "johnd")
    end

    it "triggers on event" do
      user.on(:update, &callable)
      callable.should_receive(:called).with(user)
      user.update_attributes!(:username => "johnd")
    end

    it "triggers after event" do
      user.after(:update, &callable)
      callable.should_receive(:called).with(user)
      user.update_attributes!(:username => "johnd")
    end

    it "doesn't trigger on/after events when record is invalid" do
      user.username = nil

      on_callable = Callable.new
      after_callable = Callable.new

      user
        .on(:update, &on_callable)
        .after(:update, &after_callable)

      on_callable.should_not_receive(:called)
      after_callable.should_not_receive(:called)

      user.save
    end
  end

  context "remove event" do
    let(:user) { User.create!(:username => "johndoe") }

    it "triggers before event" do
      user.before(:remove, &callable)
      callable.should_receive(:called).with(user)

      user.destroy
    end

    it "triggers on event" do
      user.on(:remove, &callable)
      callable.should_receive(:called).with(user)

      user.destroy
    end

    it "triggers after event" do
      user.after(:remove, &callable)
      callable.should_receive(:called).with(user)

      user.destroy
    end
  end
end
