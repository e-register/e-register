require 'rails_helper'

describe Presence, type: :model do
  subject { create(:presence) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:student) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:hour) }
  it { is_expected.to respond_to(:presence_type) }
  it { is_expected.to respond_to(:justification) }
  it { is_expected.to respond_to(:note) }

  it 'fetch correctly the presences' do
    stud = create(:student)

    absent = create(:presence_type_absent)
    present = create(:presence_type_present)

    create(:presence, student: stud, date: Date.yesterday, hour: 1, presence_type: absent)
    create(:presence, student: stud, date: Date.yesterday, hour: 5, presence_type: present)

    pres1 = create(:presence, student: stud, date: Date.today, hour: 1, presence_type: present)
    pres2 = create(:presence, student: stud, date: Date.today, hour: 3, presence_type: absent)

    expect(Presence.today_presences(stud)).to eq([pres1, pres2])
  end

  it 'fetch correctly the last presence' do
    stud = create(:student)

    absent = create(:presence_type_absent)
    present = create(:presence_type_present)

    create(:presence, student: stud, date: Date.yesterday, hour: 1, presence_type: absent)
    create(:presence, student: stud, date: Date.yesterday, hour: 5, presence_type: present)

    create(:presence, student: stud, date: Date.today, hour: 1, presence_type: present)
    pres = create(:presence, student: stud, date: Date.today, hour: 3, presence_type: absent)

    expect(Presence.last_today_presence(stud)).to eq(pres)
  end

  it 'returns nil if the user presence is not available' do
    stud = create(:student)

    absent = create(:presence_type_absent)
    present = create(:presence_type_present)

    create(:presence, student: stud, date: Date.yesterday, hour: 1, presence_type: absent)
    create(:presence, student: stud, date: Date.yesterday, hour: 5, presence_type: present)

    expect(Presence.last_today_presence(stud)).to be_nil
  end
end
