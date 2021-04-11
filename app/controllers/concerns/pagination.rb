module Pagination
  include ActiveSupport::Concern    

  def pagination(model_object, per_page, page_no)
    unless per_page && page_no
      return model_object
    end    
    limit = params[:per_page].to_i
    offset = limit * (params[:page_no].to_i)
    model_object = model_object.limit(limit).offset(offset)
  end  
end    
