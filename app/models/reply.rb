class Reply < ApplicationRecord 
  belongs_to :comment 
  belongs_to :user
 
  validates_presence_of :content
end
