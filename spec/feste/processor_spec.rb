require "spec_helper"

RSpec.describe Feste::Processor do
  describe "#process" do
    context "when there is a whitelist set", :stubbed_email do
      it "processes an action in the whitelist" do
        mailer = instance_double(MailerWithWhitelist, class: MailerWithWhitelist)
        message = MailerWithWhitelist.whitelist_action("test@test.com")
        processor = Feste::Processor.new(message, mailer, :whitelist_action)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_emails!)

        processor.process

        expect(processor).to have_received(:stop_delivery_to_unsubscribed_emails!)
      end

      it "does not process an action that is not on the whitelist" do
        mailer = instance_double(MailerWithWhitelist, class: MailerWithWhitelist)
        message = MailerWithWhitelist.other_action("test@test.com")
        processor = Feste::Processor.new(message, mailer, :other_action)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_emails!)

        result = processor.process

        expect(result).to be true
        expect(processor).not_to have_received(:stop_delivery_to_unsubscribed_emails!)
      end
    end

    context "when there is a blacklist set", :stubbed_email do
      it "proceses an action not on the blacklist" do
        mailer = instance_double(MailerWithBlacklist, class: MailerWithBlacklist)
        message = MailerWithBlacklist.whitelist_action("test@test.com")
        processor = Feste::Processor.new(message, mailer, :whitelist_action)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_emails!)

        processor.process

        expect(processor).to have_received(:stop_delivery_to_unsubscribed_emails!)
      end

      it "does not process an action on the blacklist" do
        mailer = instance_double(MailerWithBlacklist, class: MailerWithBlacklist)
        message = MailerWithBlacklist.blacklist_action("test@test.com")
        processor = Feste::Processor.new(message, mailer, :blacklist_action)
        allow(processor).to receive(:stop_delivery_to_unsubscribed_emails!)

        result = processor.process

        expect(result).to be true
        expect(processor).not_to have_received(:stop_delivery_to_unsubscribed_emails!)
      end
    end

    context "when a user has unsubscribed to all emails" do
      it "deletes that user's email from the devliery destinations" do
        email = "test@email.com"
        allowed_email = "allowed@email.com"

        subscriber = create_subscriber(email: email, cancelled: true)
        allowed_subscriber = create_subscriber(email: allowed_email, cancelled: false)

        mailer = instance_double(MainMailer, class: MainMailer)
        message = stubbed_email_to([email, allowed_email])
        
        Feste::Processor.new(message, mailer, :send_mail).process

        expect(message.to).not_to include(email)
        expect(message.to).to include(allowed_email)
      end
    end

    context "when a user has unsubscribed to an email" do
      it "deletes delivery destinations that have unsubscribed to that mailer" do
        email = "test@test.com"

        subscriber = create_subscriber(email: email, cancelled: false)
        feste_email = create_email(mailer: MainMailer.name, action: "send_mail")
        create_cancellation(email: feste_email, subscriber: subscriber, cancelled: true)

        mailer = instance_double(MainMailer, class: MainMailer)
        message = stubbed_email_to(email)

        Feste::Processor.new(message, mailer, :send_mail).process

        expect(message.to.empty?).to be true        
      end
    end

    context "when a user has not unsubscribed to an email" do
      it "sends the email" do
        email = "test@test.com"

        subscriber = create_subscriber(email: email, cancelled: false)
        feste_email = create_email(mailer: MainMailer.name, action: "send_mail")
        create_cancellation(email: feste_email, subscriber: subscriber, cancelled: false)

        mailer = instance_double(MainMailer, class: MainMailer)
        message = stubbed_email_to(email)

        Feste::Processor.new(message, mailer, :send_mail).process

        expect(message.to).to eq([email])    
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
    subscriber = Feste::Subscriber.create(email: email, cancelled: cancelled)
    allow(Feste::Subscriber).to(
      receive(:find_or_create_by).with(email: email).and_return(subscriber)
    )
    allow(Feste::Subscriber).to(
      receive(:find_by).with(email: email).and_return(subscriber)
    )
    subscriber
  end

  def create_email(mailer:,action:)
    feste_email = Feste::Email.create(mailer: mailer, action: action)
    allow(Feste::Email).to(
      receive(:find_or_create_by).
        with(mailer: mailer, action: action).
        and_return(feste_email)
    )
    feste_email
  end

  def create_cancellation(email:,subscriber:,cancelled:false)
    cancellation = Feste::CancelledSubscription.
      create(email: email, subscriber: subscriber, cancelled: cancelled)
    allow(Feste::CancelledSubscription).to(
      receive(:find_or_create_by).
        with(subscriber: subscriber, email: email).
        and_return(cancellation)
    )
    cancellation
  end
end