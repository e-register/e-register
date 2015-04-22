require 'rails_helper'

describe ApplicationController, type: :controller do
  it 'blocks unauthorized requests' do
    def controller.home
      raise Pundit::NotAuthorizedError
    end

    get :home

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).not_to be_empty
  end

  it 'shows unauthorized when not found' do
    def controller.home
      raise ActiveRecord::RecordNotFound
    end

    get :home

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).not_to be_empty
  end
end
