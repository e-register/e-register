require 'rails_helper'

describe KlassPolicy do
  subject { described_class }

  permissions :index? do
    let(:user) { create(:user) }

    it { is_expected.not_to permit(nil) }
    it { is_expected.to permit(user) }
  end

  permissions :show? do
    let(:admin) { create(:user_admin) }
    let(:klass) { create(:klass) }
    let(:student) { create(:user_student, with_klass: klass) }
    let(:other_student) { create(:user_student) }
    let(:teacher) { create(:user_teacher, with_klass: klass) }
    let(:other_teacher) { create(:user_teacher) }

    it { is_expected.not_to permit(nil, klass) }
    it { is_expected.to permit(admin, klass) }
    it { is_expected.to permit(student, klass) }
    it { is_expected.not_to permit(other_student, klass) }
    it { is_expected.to permit(teacher, klass) }
    it { is_expected.not_to permit(other_teacher, klass) }
  end
end
