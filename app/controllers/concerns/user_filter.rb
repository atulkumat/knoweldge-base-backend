module UserFilter
  include ActiveSupport::Concern

  def filter_by_username(model_object, name)
    unless name.present?
      return model_object
    end
    
    model_object.where('lower(first_name) like ?
                or lower(last_name) like ?',
                "%#{params[:name].downcase}%",
                "%#{params[:name].downcase}%")
  end
end
