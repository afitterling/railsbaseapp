module WebhooksExecutor
  module Events
    LOG_DATA_CREATED = "log_data_created"
    IMAGES_CREATED   = "images_created"
  end

  def execute_webhook(webhook, event, payload)
    request_body = {
      secret: webhook.secret,
      event: event,
      data: payload
    }

    RestClient.post webhook.url, request_body.to_json, {content_type: :json}
  rescue => e
  end
end
