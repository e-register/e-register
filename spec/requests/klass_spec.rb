require 'rails_helper'

describe 'Klass', type: :request do
  describe 'KlassesController#index' do
    it 'shows the klasses of the user' do
      user = create(:user_student, num_klass: 3)
      sign_in user

      visit klasses_path

      user.klasses.each do |klass|
        expect(page).to have_content(klass.name)
      end
    end

    it 'doesn\'t show the classes page for guest' do
      visit klasses_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are not authorized to perform this action.')
    end
  end

  describe 'KlassesController#show' do
    it 'shows the requested klass' do
      klass = create(:klass)
      user = create(:user_student, with_klass: klass)

      sign_in user

      create(:teacher, klass: klass)
      create(:sign, klass: klass, date: Date.today)
      create(:event, klass: klass, date: Date.today)

      visit klass_path(klass)

      klass.students.each do |stud|
        expect(page).to have_content(stud.user.full_name)
      end

      klass.teachers.each do |teach|
        expect(page).to have_content(teach.user.full_name)
      end

      klass.today_signs.each do |sign|
        expect(page).to have_content(sign.teacher.full_name)
        expect(page).to have_content(sign.subject.name)
        expect(page).to have_content(sign.lesson)
      end

      klass.today_events.each do |event|
        expect(page).to have_content(event.teacher.full_name)
        expect(page).to have_content(event.text)
      end
    end

    it 'doesn\'t show the class informations for guest' do
      klass = create(:klass)

      visit klass_path(klass)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are not authorized to perform this action.')
    end
  end
end
