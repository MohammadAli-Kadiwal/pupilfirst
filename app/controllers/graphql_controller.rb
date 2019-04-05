class GraphqlController < ApplicationController
  skip_forgery_protection

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_school: current_school,
      current_user: current_user,
      current_founder: current_founder,
      current_coach: current_school,
      current_domain: current_domain,
      current_host: current_host,
      current_startup: current_startup
    }

    result = SvappSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e # rubocop:disable Style/RescueStandardError
    raise e unless Rails.env.development?

    handle_error_in_development e
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")

    render json: { error: { message: error.message, backtrace: error.backtrace }, data: {} }, status: :internal_server_error
  end
end