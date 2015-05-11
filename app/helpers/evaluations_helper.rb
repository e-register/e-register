module EvaluationsHelper
  def grid_evaluation(evaluation)
    html = <<-EOC
<div class="evaluation-box-content">
  <div class="evaluation-box-score">#{evaluation.score.try(:as_string) || '?'}</div>
  <div class="evaluation-box-date">#{format_evaluation_date evaluation.date}</div>
</div>
EOC
    html.strip.html_safe
  end

  def evaluation_button(evaluation)
    if evaluation
      link_to grid_evaluation(evaluation), evaluation_path(evaluation),
              class: ['btn', 'btn-sm', "btn-#{evaluation.score_class}", 'evaluation-box'],
              disabled: !evaluation.visible
    else
      empty_grid_evaluation
    end
  end

  def new_evaluation_button(teacher, student_id, type_id)
    href = new_evaluation_teacher_path(teacher, student_id: student_id, type_id: type_id)
    html = <<EOC
<span class="evaluation-box-container">
  <a class="evaluation-box btn btn-sm btn-primary" href="#{href}">
    <div class="evaluation-box-content">
      <div class="evaluation-box-add">
        Add
      </div>
    </div>
  </a>
</span>
EOC
    html.strip.html_safe
  end

  private

  def format_evaluation_date(date)
    d = Date.parse date.to_s
    d.strftime '%d/%m'
  end

  def empty_grid_evaluation
    html = <<EOC
<span class="evaluation-box btn-sm">
  <div class="evaluation-box-content">
    <div class="evaluation-box-score">&nbsp;</div>
    <div class="evaluation-box-date">&nbsp;</div>
  </div>
</span>
EOC
    html.strip.html_safe
  end
end
