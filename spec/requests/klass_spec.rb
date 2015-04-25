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

  describe 'KlassesController#edit' do
    it 'edits the klass' do
      user = create(:user_admin)
      sign_in user

      klass = create(:klass)

      visit edit_klass_path(klass)

      fill_in 'Name', with: 'Foo'
      fill_in 'Detail', with: 'Bar'

      click_on 'Update'

      klass.reload

      expect(klass.name).to eq('Foo')
      expect(klass.detail).to eq('Bar')
    end

    it 'blocks a non-admin user' do
      user = create(:user_student)
      sign_in user

      klass = create(:klass)

      visit edit_klass_path(klass)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are not authorized to perform this action.')
    end

    it 'manage if an error' do
      user = create(:user_admin)
      sign_in user

      klass = create(:klass)

      visit edit_klass_path(klass)

      allow_any_instance_of(Klass).to receive(:update_attributes).and_return(false)

      click_on 'Update'

      expect(current_path).to eq(edit_klass_path(klass))
    end
  end

  describe 'KlassesController#new' do
    it 'creates a new klass with all informations correct' do
      sign_in create(:user_admin)

      visit new_klass_path

      fill_in 'Name', with: 'Foo'
      fill_in 'Detail', with: 'Bar'

      click_on 'Create'

      klass = Klass.find_by(name: 'Foo', detail: 'Bar')
      expect(klass).not_to be_nil
    end

    it 'doesn\'t create the class if non-admin' do
      sign_in create(:user_student)

      visit new_klass_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are not authorized to perform this action.')
    end

    it 'manage if an error' do
      user = create(:user_admin)
      sign_in user

      visit new_klass_path

      allow_any_instance_of(Klass).to receive(:save).and_return(false)

      click_on 'Create'

      expect(current_path).to eq(new_klass_path)
    end
  end
end
