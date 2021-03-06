require 'rails_helper'

describe 'User', type: :request do
  describe 'UsersController#show' do
    it 'shows the users information' do
      user = create(:user_student)
      sign_in create(:user_admin)

      visit user_path(user)

      expect(current_path).to eq(user_path(user))
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(user.user_group.name)

      user.klasses.each do |klass|
        expect(page).to have_content(klass.name)
        expect(page).to have_content(klass.detail)
      end
    end

    it 'displays edit and delete buttons as an admin' do
      user = create(:user_student)
      sign_in create(:user_admin)

      visit user_path(user)

      expect(page).to have_link('Edit')
      expect(page).to have_link('Delete')
    end

    it 'doesn\'t display edit and delete buttons as normal user' do
      user = create(:user_student)
      sign_in create(:user_student)

      visit user_path(user)

      expect(page).not_to have_link('Edit')
      expect(page).not_to have_link('Delete')
    end
  end

  describe 'UsersController#edit' do
    it 'edits the user' do
      user = create(:user_student)
      sign_in create(:user_admin)

      visit edit_user_path(user)

      fill_in 'Name', with: 'Foo'
      fill_in 'Surname', with: 'Bar'
      select 'Admin', from: 'User group'

      click_on 'Update'

      user.reload

      expect(user.name).to eq('Foo')
      expect(user.surname).to eq('Bar')
      expect(user.user_group.name).to eq('Admin')
    end

    it 'blocks a non-admin user' do
      user = create(:user)
      sign_in create(:user_student)

      visit edit_user_path(user)

      check_unauthorized
    end

    it 'manage if an error' do
      user = create(:user_student)
      sign_in create(:user_admin)

      visit edit_user_path(user)

      allow_any_instance_of(User).to receive(:save).and_return(false)

      click_on 'Update'

      expect(current_path).to eq(edit_user_path(user))
    end
  end

  describe 'UsersController#new' do
    it 'creates a new user with all information correct' do
      sign_in create(:user_admin)

      visit new_user_path

      fill_in 'Name', with: 'Foo'
      fill_in 'Surname', with: 'Bar'
      select 'Admin', from: 'User group'

      click_on 'Create'

      user = User.find_by(name: 'Foo', surname: 'Bar')
      expect(user).not_to be_nil
    end

    it 'doesn\'t create the user if non-admin' do
      sign_in create(:user_student)

      visit new_user_path

      check_unauthorized
    end

    it 'manage if an error' do
      sign_in create(:user_admin)

      visit new_user_path

      allow_any_instance_of(User).to receive(:save).and_return(false)

      click_on 'Create'

      expect(current_path).to eq(new_user_path)
    end
  end

  describe 'UsersController#destroy' do
    it 'deletes the user if admin' do
      user = create(:user_student)
      sign_in create(:user_admin)

      visit user_path(user)

      click_on 'Delete'

      expect(current_path).to eq(root_path)

      expect { user.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'manage if an error' do
      user = create(:user_student)
      sign_in create(:user_admin)

      visit user_path(user)

      allow_any_instance_of(User).to receive(:destroy).and_return(false)

      click_on 'Delete'

      expect(current_path).to eq(user_path(user))
      expect(page).to have_content('Error deleting the user')
    end
  end
end
