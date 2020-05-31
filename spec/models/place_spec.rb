# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Place, type: :model do
  subject(:place) { described_class.new(params) }

  let(:params) do
    {}
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_length_of(:title).is_at_most(60) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to validate_numericality_of(:latitude).is_less_than_or_equal_to(90) }
    it { is_expected.to validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90) }
    it { is_expected.to validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180) }
    it { is_expected.to validate_numericality_of(:longitude).is_less_than_or_equal_to(180) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:author) }
  end
end
