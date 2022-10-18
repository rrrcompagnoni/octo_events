class Issues::EventsController < ApplicationController
  include WebhookAuthHelper

  before_action :maybe_authorize_request

  def create
    Issues.process_event!(permitted_params(params))

    render status: 202
  end

  private

  def maybe_authorize_request
    render status: 403 unless valid_signature?(request.body.read, request.headers['X-Hub-Signature-256'])
  end

  def permitted_params(raw_params)
    event_params = raw_params.require(:event).permit(:action).to_h

    raw_params.permit(
      issue: {},
      rule: {},
      changes: {},
      repository: {},
      organization: {},
      sender: {},
      label: {},
      comment: {}
    ).to_h.merge(event_params)
  end
end
