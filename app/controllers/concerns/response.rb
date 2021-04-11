module Response
  include ActiveSupport::Concern
  
  def success_response(data)
    render json: data, status: 200    
  end
   
  def created_response(data)
    render json: data, status: 201
  end

  def bad_request_response(error)
    render json: error, status: 400
  end  

  def record_not_found_response
    head 404
  end
  
  def unauthorized_response
    head 401
  end

  def forbidden_response(error)
    render json: { error: error }, status: 403
  end  
end
