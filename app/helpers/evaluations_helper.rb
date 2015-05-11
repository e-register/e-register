module EvaluationsHelper
  #
  # opt:
  #  - skip_container: true/false
  #  - klass_test: KlassTest
  #  - teacher: Teacher
  #  - student_id: integer
  #  - type_id: integer
  def evaluation_button(evaluation, opt = {})
    html = if evaluation
             evaluation_existing_link(evaluation, opt)
           elsif opt[:klass_test]
             evaluation_missing(opt)
           else
             evaluation_empty
           end

    unless opt[:skip_container]
      html = "<span class='evaluation-box-container #{'bg-success' if opt[:klass_test]}'>#{html}</span>"
    end

    html.strip.html_safe
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

  def evaluation_button_content(score = '&nbsp;', date = '&nbsp;')
    html = <<-EOC
<div class="evaluation-box-content">
  <div class="evaluation-box-score">#{score}</div>
  <div class="evaluation-box-date">#{date}</div>
</div>
EOC
    html.strip.html_safe
  end

  def evaluation_existing_link(evaluation, opt = {})
    score = evaluation.score.try(:as_string) || '?'
    date = format_evaluation_date(evaluation.date)
    link_to evaluation_path(evaluation), class: ['btn', 'btn-sm', "btn-#{evaluation.score_class}", 'evaluation-box'],
            disabled: !evaluation.visible do
      evaluation_button_content(score, date)
    end
  end

  def evaluation_missing(opt = {})
    url = new_evaluation_teacher_path(opt[:teacher],
                                      student_id: opt[:student_id], type_id: opt[:type_id],
                                      klass_test_id: opt[:klass_test].id)
    link_to evaluation_button_content, url, class: ['evaluation-box', 'btn-sm']
  end

  def evaluation_empty
    content_tag :span, evaluation_button_content, class: ['evaluation-box', 'btn-sm']
  end

  def format_evaluation_date(date)
    d = Date.parse(date.to_s)
    d.strftime '%d/%m'
  end
end
