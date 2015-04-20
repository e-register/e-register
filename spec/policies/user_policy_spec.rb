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
end
