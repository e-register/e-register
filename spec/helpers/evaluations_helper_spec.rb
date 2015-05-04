require 'rails_helper'

describe EvaluationsHelper, type: :helper do
  describe 'format_evaluation_date' do
    it 'returns the correct date' do
      expect(helper.send(:format_evaluation_date, '07/01/1997')).to eq('07/01')
      expect(helper.send(:format_evaluation_date, '2/12/2015')).to eq('02/12')
    end

    it 'generates a good evaluation tag' do
      evaluation = build(:evaluation)

      html = helper.grid_evaluation evaluation

      expect(html).to have_content(evaluation.score.as_string)
      expect(html).to have_content(helper.send(:format_evaluation_date, evaluation.date))
    end
  end
end
