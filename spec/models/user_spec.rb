# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new(params) }

  let(:params) do
    {}
  end

  describe 'model index in db' do
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:username).unique }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:sex) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(60) }
    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(60) }

    it {
      expect(user).to validate_numericality_of(:age).is_less_than(200)
                                                    .is_greater_than(0)
    }

    it {
      expect(user).to validate_numericality_of(:sex).is_less_than_or_equal_to(3)
                                                    .is_greater_than(0)
    }
  end

  describe 'associations' do
    it { is_expected.to have_many :places }
    it { is_expected.to have_many :active_friendships }
    it { is_expected.to have_many :following }
    it { is_expected.to have_many :fav_places }
  end

  describe 'following and unfollowing a user' do
    it { is_expected.to respond_to(:follow) }
    it { is_expected.to respond_to(:unfollow) }
  end

  describe 'following' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:friend) { FactoryBot.create(:user) }

    before do
      user.follow(friend)
    end

    it { is_expected.to be_following(friend) }
  end
end
# rubocop:enable Metrics/BlockLength
