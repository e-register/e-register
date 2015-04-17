require 'rails_helper'

describe Event, type: :model do
  subject { create(:event) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:klass) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:text) }
  it { is_expected.to respond_to(:visible) }

  check_required_field :event, [ :teacher, :klass, :date, :text ]
end
