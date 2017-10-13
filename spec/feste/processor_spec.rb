require "spec_helper"

RSpec.describe Feste::Processor do
  describe "#process" do
    context "when there is a whitelist set", :stubbed_email do
      it "processes an action in the whitelist" do
        user = User.new
        mailer = instance_double(
          MailerWithWhitelist,
          class: MailerWithWhitelist
        )
        message = stubbed_email_to(user.email)
        processor = Feste::Processor.
          new(message, mailer, :whitelist_action, user)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_user!)

        processor.process

        expect(processor).to have_received(:stop_delivery_to_unsubscribed_user!)
      end

      it "does not process an action that is not on the whitelist" do
        user = User.new
        mailer = instance_double(
          MailerWithWhitelist,
          class: MailerWithWhitelist
        )
        message = stubbed_email_to(user.email)
        processor = Feste::Processor.new(message, mailer, :other_action, user)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_user!)

        result = processor.process

        expect(result).to be true
        expect(processor).
          not_to have_received(:stop_delivery_to_unsubscribed_user!)
      end
    end

    context "when there is a blacklist set", :stubbed_email do
      it "proceses an action not on the blacklist" do
        user = User.new
        mailer = instance_double(
          MailerWithBlacklist,
          class: MailerWithBlacklist
        )
        message = MailerWithBlacklist.whitelist_action("test@test.com")
        processor = Feste::Processor.
          new(message, mailer, :whitelist_action, user)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_user!)

        processor.process

        expect(processor).to have_received(:stop_delivery_to_unsubscribed_user!)
      end

      it "does not process an action on the blacklist" do
        user = User.new
        mailer = instance_double(
          MailerWithBlacklist,
          class: MailerWithBlacklist
        )
        message = MailerWithBlacklist.blacklist_action("test@test.com")
        processor = Feste::Processor.
          new(message, mailer, :blacklist_action, user)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_user!)

        result = processor.process

        expect(result).to be true
        expect(processor).
          not_to have_received(:stop_delivery_to_unsubscribed_user!)
      end
    end

    context "when a user has unsubscribed to all emails" do
      it "deletes all message destinations" do
        user = User.new

        subscriber = create_subscriber(email: user.email, cancelled: true)
        mailer = instance_double(MainMailer, class: MainMailer)
        message = stubbed_email_to(user.email)
        
        Feste::Processor.new(message, mailer, :send_mail, user).process

        expect(message.to.empty?).to be true
      end
    end

    context "when a user has unsubscribed to an email" do
      it "deletes all message destinations" do
        user = User.new

        subscriber = create_subscriber(email: user.email, cancelled: false)
        feste_email = create_email(mailer: MainMailer.name, action: "send_mail")
        create_cancellation(
          email: feste_email,
          subscriber: subscriber,
          cancelled: true
        )

        mailer = instance_double(MainMailer, class: MainMailer)
        message = stubbed_email_to(user.email)

        Feste::Processor.new(message, mailer, :send_mail, user).process

        expect(message.to.empty?).to be true        
      end
    end

    context "when a user has not unsubscribed to an email" do
      it "sends the email" do
        user = User.new

        subscriber = create_subscriber(email: user.email, cancelled: false)
        feste_email = create_email(mailer: MainMailer.name, action: "send_mail")
        create_cancellation(
          email: feste_email,
          subscriber: subscriber,
          cancelled: false
        )

        mailer = instance_double(MainMailer, class: MainMailer)
        message = stubbed_email_to(user.email)

        Feste::Processor.new(message, mailer, :send_mail, user).process

        expect(message.to).to eq([user.email])    
      end
    end
  end

  def stubbed_email_to(email)
    Mail.new do
      to email
      from "test@test.com"
      subject "test"
      body "this"
    end
  end

  def create_subscriber(email: ,cancelled: false)
    subscriber = double(
      Feste::Subscriber,
      email: email,
      cancelled: cancelled
    )
    allow(Feste::Subscriber).to(
      receive(:find_or_create_by).with(email: email).and_return(subscriber)
    )
    allow(Feste::Subscriber).to(
      receive(:find_by).with(email: email).and_return(subscriber)
    )
    subscriber
  end

  def create_email(mailer:,action:)
    feste_email = double(
      Feste::Email,
      mailer: mailer,
      action: action
    )
    allow(Feste::Email).to(
      receive(:find_or_create_by).
        with(mailer: mailer, action: action).
        and_return(feste_email)
    )
    feste_email
  end

  def create_cancellation(email:,subscriber:,cancelled:false,token:"token")
    cancellation = double(
      Feste::CancelledSubscription,
      email: email,
      subscriber: subscriber,
      cancelled: cancelled
    )
    allow(Feste::CancelledSubscription).to(
      receive(:find_or_create_by).
        with(subscriber: subscriber, email: email).
        and_return(cancellation)
    )
    cancellation
  end
end