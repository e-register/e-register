require 'rails_helper'

describe EvaluationType, type: :model do
  subject { create(:evaluation_type) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to be_valid }

  check_unique_field(:evaluation_type, :name, 'Written', create_method: :new)
  check_required_field(:evaluation_type, :name)
end
