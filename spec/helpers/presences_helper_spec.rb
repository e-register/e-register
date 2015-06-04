require 'rails_helper'

describe PresencesHelper, type: :helper do
  describe 'presence_badge' do
    it 'return the html with the right content' do
      present = create(:presence, presence_type: create(:presence_type_present))
      absent = create(:presence, presence_type: create(:presence_type_absent))

      present_badge = helper.presence_badge(present)
      expect(present_badge).to include 'Present'
      expect(present_badge).to include 'success'

      absent_badge = helper.presence_badge(absent)
      expect(absent_badge).to include 'Absent'
      expect(absent_badge).to include 'danger'
    end
  end
end
