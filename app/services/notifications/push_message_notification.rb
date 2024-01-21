require 'fcm'

class Notifications::PushMessageNotification < ApplicationService
  def initialize(message)
    @message = message
  end

  def call
    fcm = FCM.new(ENV['FIREBASE_SEVER_KEY'])
    fcm.send(@message.recipients.pluck(:device_token), notification_options)
  end

  private

  def notification_options
    {
      notification: {
        title: "You have a new message from #{@message.user.name}!",
        body: @message.content
      }
    }
  end
end
