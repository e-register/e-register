module EvaluationsHelper
  def grid_evaluation(evaluation)
    html = <<EOC
<div class="grid-evaluation-content">
  <div class="grid-evaluation-score">#{evaluation.score.try(:as_string) || '?'}</div>
  <div class="grid-evaluation-date">#{format_evaluation_date evaluation.date}</div>
</div>
EOC
    html.html_safe
  end

  private

  def format_evaluation_date(date)
    d = Date.parse date.to_s
    d.strftime '%d/%m'
  end
end
