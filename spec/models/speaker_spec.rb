# frozen_string_literal: true

# == Schema Information
#
# Table name: speakers
#
#  id         :bigint           not null, primary key
#  bio        :text
#  image_url  :string
#  links      :jsonb
#  name       :string
#  tagline    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Speaker, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:talks).dependent(:destroy) }
    it { is_expected.to have_many(:events).through(:talks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:bio) }
    it { is_expected.to validate_presence_of(:image_url) }
  end

  describe 'scopes' do
    it 'orders speakers by name' do
      speaker_b = create(:speaker, name: 'B Speaker')
      speaker_a = create(:speaker, name: 'A Speaker')
      expect(Speaker.ordered_by_name).to eq([speaker_a, speaker_b])
    end
  end
  context 'when links are not present' do
    it 'validates the social media links' do
      speaker = build(:speaker)
      speaker1 = build(:speaker, :with_empty_links)

      expect(speaker).to be_valid
      expect(speaker1).to be_valid
    end
  end

  context 'when links are present' do
    describe 'with valid links' do
      it 'validates the social media links' do
        speaker = build(:speaker, :with_valid_links)

        expect(speaker).to be_valid
      end
    end

    describe 'with invalid links' do
      it 'validates the social media links' do
        speaker = build(:speaker, :with_invalid_links)

        expect(speaker).to be_invalid
        expect(speaker.errors[:links]).to include('This social media is not allowed')
      end
    end
  end

  describe 'callbacks' do
    describe '#format_links' do
      let(:links) { { 'Twitter' => 'link_twitter', 'LinkedIn' => 'link_linkedIn' } }

      it 'downcases the keys of the links' do
        speaker = build(:speaker, links: links)

        speaker.valid?
        expect(speaker.links).to eq({ 'twitter' => 'link_twitter', 'linkedin' => 'link_linkedIn' })
      end
    end
  end
end
