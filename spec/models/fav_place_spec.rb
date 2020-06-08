# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavPlace, type: :model do
  subject(:fav_place) { described_class.new(params) }

  let(:params) do
    {}
  end

  describe 'model index in db' do
    it { is_expected.to have_db_index(:likeable_id) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[user_id likeable_id likeable_type]).unique }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:likeable_id) }
    it { is_expected.to validate_presence_of(:likeable_type) }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :likeable }
  end
end
