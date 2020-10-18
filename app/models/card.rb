require 'super_memo'

class Card < ActiveRecord::Base
  include ActiveModel::Validations
  include StringFormatter

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

  scope :pending, -> { where('review_date <= ?', Time.now).order('RANDOM()') }
  scope :repeating, -> { where('quality < ?', 4).order('RANDOM()') }

  def check_translation(user_translation)
    distance = Levenshtein.distance(full_downcase(translated_text),
                                    full_downcase(user_translation))

    sm_hash = SuperMemo.algorithm(interval, repeat, efactor, attempt, distance, 1)

    if distance <= 1
      sm_hash[:review_date] = Time.zone.now + interval.to_i.days
      sm_hash[:attempt] = 1
      update(sm_hash)
      { state: true, distance: distance }
    else
      sm_hash[:attempt] = [attempt + 1, 5].min
      update(sm_hash)
      { state: false, distance: distance }
    end
  end

  def self.pending_cards_notification
    users = User.where.not(email: nil)
    users.each do |user|
      CardsMailer.pending_cards_notification(user.email).deliver if user.cards.pending.any?
    end
  end

  protected

  def set_review_date_as_now
    self.review_date = Time.now
  end
end
