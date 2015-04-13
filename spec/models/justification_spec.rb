require 'rails_helper'

describe Justification, type: :model do
  subject { create(:justification) }

  it { is_expected.to respond_to(:reason) }

  check_unique_field(:justification, :reason, 'Illness', create_mode: :new)
  check_required_field(:justification, :reason)
end
