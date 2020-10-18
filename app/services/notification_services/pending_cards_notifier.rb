class NotificationServices::PendingCardsNotifier
  def initialize
    @users = User.where.not(email: :nil)
  end

  def call
    @users.each do |user|
      CardsMailer.pending_cards_notification(user.email).deliver if user.cards.pending.any?
    end
  end
end
