class ApplicationController < ActionController::API
  before_action :set_params

  def set_params
    hash = {}
    request.query_parameters.each do |key, value|
     hash[key] = value.to_s
    end
    @params = hash
  end
end
