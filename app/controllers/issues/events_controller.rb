class Issues::EventsController < ApplicationController
  include WebhookAuthHelper
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :maybe_authorize_request, only: [:create]

  http_basic_authenticate_with name: BasicAuthHelper.user, password: BasicAuthHelper.password, except: :create

  def create
    Issues.process_event!(permitted_params(params))

    render status: 202
  end

  def index
    allowed_params = params.permit(:issue_number, page: [:number, :size]).to_h

    events = Issues.list_events(allowed_params.fetch(:issue_number), allowed_params.fetch(:page, {}))

    paginate json: events, page: events.current_page, per_page: events.limit_value
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
