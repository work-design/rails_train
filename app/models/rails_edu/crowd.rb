module RailsEdu::Crowd
  extend ActiveSupport::Concern
  included do
    has_many :crowd_students
    has_many :students, through: :crowd_students, source_type: 'Profile'
  
    has_one_attached :logo
  end
  
end
