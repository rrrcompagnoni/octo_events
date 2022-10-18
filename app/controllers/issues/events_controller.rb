class Issues::EventsController < ApplicationController
  def create
    Issues.process_event!(permitted_params(params))

    render status: 202
  end

  private

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
