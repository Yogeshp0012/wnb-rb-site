# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id               :bigint           not null, primary key
#  date             :datetime
#  description      :text
#  location         :string           default("virtual")
#  panel_video_link :text
#  title            :string
#  type             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Event < ApplicationRecord
  has_many :talks, dependent: :destroy
  has_many :speakers, through: :talks

  validates :title, :location, :date, presence: true
end
