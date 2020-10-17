module TrainerHelper
  def create_and_check_review_card(user, block, repeat, translate)
    card = create(:card, user: user, block: block, repeat: repeat)
    put :review_card, params: { card_id: card.id, user_translation: translate }
    Card.find(card.id)
  end

  def check_review_card(card, translate, number)
    number.times do
      put :review_card, params: { card_id: card.id, user_translation: translate }
    end
    Card.find(card.id)
  end
end
