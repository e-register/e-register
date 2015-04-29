require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#format_date' do
    it 'formats the date correctly' do
      expect(helper.format_date(Date.parse('1997-01-07'))).to eq('07/01/1997')
      expect(helper.format_date('29/04/2015')).to eq('29/04/2015')
    end
  end
end
