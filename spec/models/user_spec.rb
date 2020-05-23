# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new(params) }

  let(:params) do
    {}
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:sex) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(60) }
    it { is_expected.to validate_length_of(:username).is_at_most(15) }
    it { is_expected.to validate_numericality_of(:age).is_greater_than(0) }
    it {
      expect(user).to validate_numericality_of(:sex).is_less_than_or_equal_to(3)
                                                    .is_greater_than(0)
    }
  end
end
