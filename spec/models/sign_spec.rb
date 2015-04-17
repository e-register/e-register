require 'rails_helper'

describe Sign, type: :model do
  subject { create(:sign) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:subject) }
  it { is_expected.to respond_to(:klass) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:hour) }
  it { is_expected.to respond_to(:lesson) }

  check_required_field :sign, [ :teacher, :subject, :klass, :date, :hour ]
end
