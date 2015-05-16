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

  permissions :new? do
    let(:klass) { create(:klass) }
    let(:teacher) { create(:teacher, klass: klass) }
    let(:student) { create(:student, klass: klass) }
    let(:other_valid_teacher) { create(:teacher, klass: klass) }
    let(:other_teacher) { create(:teacher) }
    let(:other_student) { create(:student) }
    let(:admin) { create(:user_admin) }
    let(:presence) { build(:presence, teacher: teacher.user, klass: klass) }

    it { is_expected.to_not permit(nil, presence) }
    it { is_expected.to     permit(teacher.user, presence) }
    it { is_expected.to_not permit(other_teacher.user, presence) }
    it { is_expected.to     permit(other_valid_teacher.user, presence) }
    it { is_expected.to_not permit(student.user, presence) }
    it { is_expected.to_not permit(other_student.user, presence) }
    it { is_expected.to     permit(admin, presence) }
  end

  permissions :create? do
    let(:klass) { create(:klass) }
    let(:teacher) { create(:teacher, klass: klass) }
    let(:student) { create(:student, klass: klass) }
    let(:other_valid_teacher) { create(:teacher, klass: klass) }
    let(:other_teacher) { create(:teacher) }
    let(:other_student) { create(:student) }
    let(:admin) { create(:user_admin) }
    let(:presence) { build(:presence, teacher: teacher.user, student: student) }

    it { is_expected.to_not permit(nil, presence) }
    it { is_expected.to     permit(teacher.user, presence) }
    it { is_expected.to_not permit(other_teacher.user, presence) }
    it { is_expected.to     permit(other_valid_teacher.user, presence) }
    it { is_expected.to_not permit(student.user, presence) }
    it { is_expected.to_not permit(other_student.user, presence) }
    it { is_expected.to     permit(admin, presence) }
  end

  describe 'permitted_attributes' do
    let(:klass) { create(:klass) }
    let(:teacher) { create(:teacher, klass: klass) }
    let(:student) { create(:student, klass: klass) }
    let(:other_valid_teacher) { create(:teacher, klass: klass) }
    let(:other_teacher) { create(:teacher) }
    let(:other_student) { create(:student) }
    let(:admin) { create(:user_admin) }
    let(:presence) { build(:presence, teacher: teacher.user, student: student) }
    let(:permitted_attributes) { [:teacher_id, :student_id, :date, :hour, :presence_type_id, :justification_id, :note] }

    it 'disallow all for guest' do
      expect(subject.new(nil, presence).permitted_attributes).to match_array([])
    end
    it 'disallow all for students' do
      expect(subject.new(student.user, presence).permitted_attributes).to match_array([])
      expect(subject.new(other_student.user, presence).permitted_attributes).to match_array([])
    end
    it 'allows only the valid teachers' do
      expect(subject.new(teacher.user, presence).permitted_attributes).to match_array(permitted_attributes)
      expect(subject.new(other_valid_teacher.user, presence).permitted_attributes).to match_array(permitted_attributes)
      expect(subject.new(other_teacher.user, presence).permitted_attributes).to match_array([])
    end
    it 'allows all for admin' do
      expect(subject.new(admin, presence).permitted_attributes).to match_array(permitted_attributes)
    end
  end
end
