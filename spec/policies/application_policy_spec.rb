require 'rails_helper'

describe ApplicationPolicy do
  subject { described_class }

  permissions :show?, :index?, :new?, :create?, :edit?, :update?, :destroy? do
    it { is_expected.to_not permit(nil, nil) }
  end
end
