require 'rails_helper'

describe PresencePolicy do
  subject { described_class }

  permissions :show? do
    let(:klass) { create(:klass) }
    let(:teacher) { create(:teacher, klass: klass) }
    let(:student) { create(:student, klass: klass) }
    let(:other_valid_teacher) { create(:teacher, klass: klass) }
    let(:other_teacher) { create(:teacher) }
    let(:other_student) { create(:student) }
    let(:admin) { create(:user_admin) }
    let(:presence) { create(:presence, teacher: teacher.user, student: student) }

    it { is_expected.to_not permit(nil, presence) }
    it { is_expected.to     permit(teacher.user, presence) }
    it { is_expected.to     permit(student.user, presence) }
    it { is_expected.to     permit(other_valid_teacher.user, presence) }
    it { is_expected.to_not permit(other_teacher.user, presence) }
    it { is_expected.to_not permit(other_student.user, presence) }
    it { is_expected.to     permit(admin, presence) }
  end
end
