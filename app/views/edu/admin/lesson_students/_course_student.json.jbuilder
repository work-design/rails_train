json.extract! course_student,
              :id,
              :state,
              :created_at
json.student course_student.student,
             :id,
             :real_name,
             :nick_name
json.attended @lesson.student_ids.include?(course_student.student_id)
