module UsersHelper
  def student_presence_badge(student, today_presences)
    student_presences = today_presences.select { |p| p.student == student }
    student_presences.sort_by { |x| [x.hour, x.created_at] }

    # no mark: student present
    if student_presences.empty?
      student_present
    # the last one is present? so the user is late
    elsif student_presences.last.presence_type.present
      student_late
    # the last one is absent? if it's the first hour he's absent
    elsif student_presences.last.hour == 1
      student_absent
    # otherwise the user has left the class
    else
      student_left
    end
  end

  private

  def student_present
    build_label('success', 'Present')
  end

  def student_absent
    build_label('danger', 'Absent')
  end

  def student_late
    build_label('warning', 'Late')
  end

  def student_left
    build_label('info', 'Left')
  end

  def build_label(label, text)
    "<span class=\"label label-#{label}\">#{text}</span>".html_safe
  end
end
