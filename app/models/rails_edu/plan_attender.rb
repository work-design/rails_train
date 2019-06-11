module RailsEdu::PlanAttender
  extend ActiveSupport::Concern
  
  included do
    belongs_to :course
    belongs_to :course_student
    belongs_to :course_crowd, optional: true
    belongs_to :lesson, optional: true
    
    before_validation :sync_course_student
  end
  
  def sync_course_student
    if course_student
      self.attender_type = course_student.student_type
      self.attender_id = course_student.student_id
      
      self.course_id = course_student.course_id
      self.course_crowd_id = course_student.course_crowd_id
    end
  end
  
end
