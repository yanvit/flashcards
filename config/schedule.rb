every :day, at: '11:00 am' do
  runner 'NotificationServices::PendingCardsNotifier.new.call'
end
