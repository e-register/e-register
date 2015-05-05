module EvaluationsHelper
  def grid_evaluation(evaluation)
    html = <<EOC
<div class="evaluation-box-content" #{'style="color: blue;"' if evaluation.klass_test}>
  <div class="evaluation-box-score">#{evaluation.score.try(:as_string) || '?'}</div>
  <div class="evaluation-box-date">#{format_evaluation_date evaluation.date}</div>
</div>
EOC
    html.html_safe
  end

  def evaluation_button(evaluation)
    if evaluation
      link_to grid_evaluation(evaluation), evaluation_path(evaluation),
              class: ['btn', 'btn-sm', "btn-#{evaluation.score_class}", 'evaluation-box']
    else
      '<span class="evaluation-box btn-sm"></span>'.html_safe
    end
  end

  private

  def format_evaluation_date(date)
    d = Date.parse date.to_s
    d.strftime '%d/%m'
  end
end
