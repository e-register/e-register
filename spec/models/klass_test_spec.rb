require 'rails_helper'

describe KlassTest, type: :model do
  subject { create(:klass_test) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:evaluation_scale) }
end
