require 'fcm'

class Notifications::PushMessageNotification < ApplicationService
  def initialize(message)
    @message = message
  end

  def call
    fcm = FCM.new(
      ENV['API_KEY'],
      ENV['FIREBASE_CREDENTIALS_PATH'],
      ENV['FIREBASE_PROJECT_ID'],
    )
    Rails.logger.info 'Start pushing notification ======'
    @message.recipients.pluck(:device_token).each do |token|
      Rails.logger.info fcm.send_v1(message(token))
    end
    Rails.logger.info 'End pushing notification ======'
  end

  private

  def message(device_token, options = {})
    message = {
      # 'topic': "89023", # OR token if you want to send to a specific device
      'token': device_token,
      'data': {
        payload: payload_json
      },
      'notification': notification,
      'android': {
        'notification': {
          "click_action": "TOP_STORY_ACTIVITY",
          **notification
        }
      },
      'apns': {
        payload: {
          aps: {
            sound: "default",
            category: "#{Time.zone.now.to_i}"
          }
        }
      },
      'fcm_options': {
        analytics_label: 'Label'
      }
    }
  end

  def notification
    {
      title: "You have a new message from #{@message.user.name}!",
      body: @message.content
    }
  end

  def payload_json
    @message.to_json
  end
end
