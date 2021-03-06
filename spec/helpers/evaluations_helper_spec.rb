require 'rails_helper'

describe EvaluationsHelper, type: :helper do
  describe 'format_evaluation_date' do
    it 'returns the correct date' do
      expect(helper.send(:format_evaluation_date, '07/01/1997')).to eq('07/01')
      expect(helper.send(:format_evaluation_date, '2/12/2015')).to eq('02/12')
    end
  end

  describe 'evaluation_button' do
    it 'generates a good evaluation tag' do
      evaluation = create(:evaluation)

      html = helper.evaluation_button evaluation

      expect(html).to have_content(evaluation.score.as_string)
      expect(html).to have_content(helper.send(:format_evaluation_date, evaluation.date))
    end

    it 'generates a link to the new_evaluation_teacher_path with the klass_test' do
      klass_test = create(:klass_test)

      html = helper.evaluation_button(nil, klass_test: klass_test, teacher: klass_test.teacher, student_id: 123456, type_id: 654321)

      href = new_evaluation_teacher_path(klass_test.teacher, klass_test_id: klass_test.id, student_id: 123456, type_id: 654321)

      expect(html).to include(href.gsub '&', '&amp;')
      expect(html).to match /&nbsp;.+&nbsp;/m
    end

    it 'generates an empty tag if the evaluation is missing' do
      html = helper.evaluation_button nil

      expect(html).to match /&nbsp;.+&nbsp;/m
    end

    it 'generates an add tag for the student' do
      teacher = create(:teacher)

      html = helper.new_evaluation_button(teacher, 123456789, 987654321)

      expect(html).to include(teacher.id.to_s)
      expect(html).to include('123456789')
      expect(html).to include('987654321')
      expect(html).to include('Add')
    end
  end
end
