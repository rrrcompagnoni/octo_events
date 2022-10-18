ApiPagination.configure do |config|
  config.paginator = :kaminari

  config.page_param do |params|
    page = params.permit(page: [:number]).to_h

    page[:page][:number] if params[:page].is_a?(ActionController::Parameters)
  end

  config.per_page_param do |params|
    page = params.permit(page: [:size]).to_h

    page[:page][:size] if params[:page].is_a?(ActionController::Parameters)
  end
end
