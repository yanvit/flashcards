require 'super_memo'

class Card < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :block

  before_validation :set_review_date_as_now, on: :create

  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }
  validates :block_id,
            presence: { message: 'Выберите колоду из выпадающего списка.' }
  validates :interval, :repeat, :efactor, :quality, :attempt, presence: true
  validates_with TextDifferenceValidator

  mount_uploader :image, CardImageUploader

  scope :pending, -> { where('review_date <= ?', Time.now) }
  scope :repeating, -> { where('quality < ?', 4) }
  scope :randomly, -> { order('RANDOM()') }

  protected

  def set_review_date_as_now
    self.review_date = Time.now
  end
end
