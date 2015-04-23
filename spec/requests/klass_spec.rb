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

    it 'doesn\' show the classes page for guest' do
      visit klasses_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are not authorized to perform this action.')
    end
  end
end
