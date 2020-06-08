# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Friendship, type: :model do
  subject(:friendship) { described_class.new(params) }

  let(:params) do
    {}
  end

  describe 'model index in db' do
    it { is_expected.to have_db_index(:friend_id) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[user_id friend_id]).unique }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:friend_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :friend }
  end
end
