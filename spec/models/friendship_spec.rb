# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Friendship, type: :model do
  subject { friendship }

  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) }
  let(:friendship) { FactoryBot.create(:friendship) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:friend_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :friend }
  end
end
