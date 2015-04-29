require 'rails_helper'

describe EvaluationPolicy do
  subject { described_class }

  permissions :index? do
    let(:user) { create(:user) }

    it { is_expected.not_to permit(nil) }
    it { is_expected.to permit(user) }
  end

  permissions :show? do
    let(:student) { create(:student) }
    let(:other_student) { create(:student) }
    let(:teacher) { create(:teacher) }
    let(:other_teacher) { create(:teacher) }
    let(:admin) { create(:user_admin) }
    let(:eval) { create(:evaluation, teacher: teacher, student: student) }

    it { is_expected.to_not permit(nil, eval) }
    it { is_expected.to permit(student.user, eval) }
    it { is_expected.not_to permit(other_student.user, eval) }
    it { is_expected.to permit(teacher.user, eval) }
    it { is_expected.not_to permit(other_teacher.user, eval) }
    it { is_expected.to permit(admin, eval) }
  end

  permissions :create? do
    let(:student) { create(:student) }
    let(:other_student) { create(:student) }
    let(:teacher) { create(:teacher) }
    let(:other_teacher) { create(:teacher) }
    let(:admin) { create(:user_admin) }
    let(:eval) { create(:evaluation, teacher: teacher, student: student) }

    it { is_expected.to_not permit(nil, eval) }
    it { is_expected.to_not permit(student.user, eval) }
    it { is_expected.to_not permit(other_student.user, eval) }
    it { is_expected.to permit(teacher.user, eval) }
    it { is_expected.to_not permit(other_teacher.user, eval) }
    it { is_expected.to permit(admin, eval) }
  end

  describe 'permitted_attributes' do
    let(:student) { create(:student) }
    let(:other_student) { create(:student) }
    let(:teacher) { create(:teacher) }
    let(:other_teacher) { create(:teacher) }
    let(:admin) { create(:user_admin) }
    let(:evaluation) { create(:evaluation, teacher: teacher, student: student) }
    let(:permitted_attributes) { [:teacher_id, :student, :date, :score, :score_id, :evaluation_type_id, :description] }

    it 'disallow all for guest' do
      expect(subject.new(nil, evaluation).permitted_attributes).to match_array([])
    end
    it 'disallow all for students' do
      expect(subject.new(student.user, evaluation).permitted_attributes).to match_array([])
      expect(subject.new(other_student.user, evaluation).permitted_attributes).to match_array([])
    end
    it 'allows only the owner teacher' do
      expect(subject.new(teacher.user, evaluation).permitted_attributes).to match_array(permitted_attributes)
      expect(subject.new(other_teacher.user, evaluation).permitted_attributes).to match_array([])
    end
    it 'disallow all for guest' do
      expect(subject.new(admin, evaluation).permitted_attributes).to match_array(permitted_attributes)
    end
  end
end
