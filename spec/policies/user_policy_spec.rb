require 'rails_helper'

describe UserPolicy do
  subject { described_class }

  permissions :show? do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:admin) { create(:user_admin) }

    it { is_expected.not_to permit(nil, user) }
    it { is_expected.to permit(user, user) }
    it { is_expected.not_to permit(other, user) }
    it { is_expected.to permit(admin, user) }
  end

  permissions :update?, :destroy? do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:admin) { create(:user_admin) }

    it { is_expected.not_to permit(nil, user) }
    it { is_expected.not_to permit(user, user) }
    it { is_expected.not_to permit(user, other) }
    it { is_expected.to permit(admin, user) }
  end

  describe 'permitted_attributes' do
    let(:user) { create(:user) }
    let(:admin) { create(:user_admin) }

    it 'disallow all for non-admin' do
      expect(subject.new(user, user).permitted_attributes).to match_array([])
    end
    it 'allows attr for admin' do
      expect(subject.new(admin, user).permitted_attributes).to match_array([:name, :surname, :user_group_id])
    end
  end
end
