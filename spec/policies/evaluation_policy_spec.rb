require 'rails_helper'

describe EvaluationPolicy do
  subject { described_class }

  permissions :index? do
    let(:user) { create(:user) }

    it { is_expected.not_to permit(nil) }
    it { is_expected.to permit(user) }
  end
end
