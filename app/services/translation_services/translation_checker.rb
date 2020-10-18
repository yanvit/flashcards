class TranslationServices::TranslationChecker
  include StringFormatter

  def initialize(card, user_translation)
    @card = card
    @user_translation = user_translation
  end

  def call
    distance = Levenshtein.distance(full_downcase(@card.translated_text),
                                    full_downcase(@user_translation))

    sm_hash = SuperMemo.algorithm(
      @card.interval, @card.repeat, @card.efactor, @card.attempt, distance, 1
    )

    if distance <= 1
      sm_hash[:review_date] = Time.zone.now + @card.interval.to_i.days
      sm_hash[:attempt] = 1

      @card.update(sm_hash)

      { state: true, distance: distance }
    else
      sm_hash[:attempt] = [@card.attempt + 1, 5].min

      @card.update(sm_hash)

      { state: false, distance: distance }
    end
  end
end
