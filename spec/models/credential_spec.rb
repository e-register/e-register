require 'rails_helper'

describe Credential, type: :model do
  subject { create(:credential) }

  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:username) }
  it { is_expected.to respond_to(:password_hash) }

  check_unique_field(:credential, :username, 'pippo')
  check_required_field(:credential, [:user, :username, :password_hash])

  it 'stores password in a hashed way' do
    cred = create(:credential, password: 'secret')
    pass = BCrypt::Password.new(cred.password_hash)
    expect(pass).to eq('secret')

    expect(cred.password_hash).to_not eq('secret')
    expect(pass).to_not eq('Secret')
  end

  it 'checks if the password is valid' do
    cred = create(:credential, password: 'secret')
    expect(cred).to be_valid_password('secret')
    expect(cred).to_not be_valid_password('Secret')
  end

  it 'updates password using password=' do
    cred = create(:credential, password: 'secret')

    expect(cred).not_to be_valid_password('heLLo#w*rld')

    cred.password = 'heLLo#w*rld'

    cred.reload

    expect(cred).not_to be_valid_password('secret')
    expect(cred).to be_valid_password('heLLo#w*rld')
  end
end
