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
end
