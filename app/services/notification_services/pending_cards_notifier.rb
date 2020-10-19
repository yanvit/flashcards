module NotificationServices
  class PendingCardsNotifier
    def initialize
      @users = Card.includes(:user).pending.select(:user_id).distinct.map(&:user)
    end

    def call
      @users.each do |user|
        CardsMailer.pending_cards_notification(user.email).deliver
      end
    end
  end
end
