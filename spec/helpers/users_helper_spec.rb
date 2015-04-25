require 'rails_helper'

describe UsersHelper, :type => :helper do
  describe '#student_presence_badge' do
    let(:klass) { create(:klass) }
    let(:stud) { create(:student, klass: klass) }

    it 'return present correctly' do
      today_presences = klass.today_presences

      expect(helper.student_presence_badge(stud, today_presences)).to include('Present')
    end

    it 'return absent correctly' do
      create(:presence, student: stud, date: Date.today, hour: 1, presence_type: create(:presence_type_absent))

      today_presences = klass.today_presences

      expect(helper.student_presence_badge(stud, today_presences)).to include('Absent')
    end

    it 'return late correctly' do
      create(:presence, student: stud, date: Date.today, hour: 1, presence_type: create(:presence_type_absent))
      create(:presence, student: stud, date: Date.today, hour: 2, presence_type: create(:presence_type_present))

      today_presences = klass.today_presences

      expect(helper.student_presence_badge(stud, today_presences)).to include('Late')
    end

    it 'return left correctly' do
      create(:presence, student: stud, date: Date.today, hour: 3, presence_type: create(:presence_type_absent))

      today_presences = klass.today_presences

      expect(helper.student_presence_badge(stud, today_presences)).to include('Left')
    end
  end
end
