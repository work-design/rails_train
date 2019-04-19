class CoursePlan < ApplicationRecord
  include RailsBookingBooked

  attribute :booking_on, :date
  attribute :time_bookings_count, :integer, default: 0

  belongs_to :course
  belongs_to :time_item
  belongs_to :course_crowd
  belongs_to :lesson, optional: true
  belongs_to :teacher, optional: true
  belongs_to :room, optional: true

  has_many :lesson_students, dependent: :nullify
  has_many :students, through: :lesson_students, source_type: 'Profile'

  validates :booking_on, presence: true

  scope :valid, -> { default_where('booking_on-gte': Date.today) }

  after_initialize if: :new_record? do
    if course_crowd
      self.course_id = course_crowd.course_id
      self.teacher_id ||= course_crowd.teacher_id
    end
  end

  def self.events(start: Time.current, finish: start + 7.days)
    self.default_where('booking_on-gte': start, 'booking_on-lte': finish).each do |i|
      {
        id: i.id,
        start: i.start_at.change(date.parts).strftime('%FT%T'),
        end: i.finish_at.change(date.parts).strftime('%FT%T'),
        title: "#{self.room.name} #{self.course.title}",
        extendedProps: {
          title: self.course.title,
          room: self.room.as_json(only: [:id], methods: [:name]),
          crowd: self.course_crowd.crowd.as_json(only: [:id, :name])
        }
      }
    end.flatten
  end

end
