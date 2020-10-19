module TranslationServices
  class ProcessTranslation
    include StringFormatter

    def initialize(
      interval:, repeat:, efactor:, attempt:,
      correct_translation:, provided_translation:
    )
      @interval = interval
      @repeat = repeat
      @efactor = efactor
      @attempt = attempt
      @correct_translation = correct_translation
      @provided_translation = provided_translation
    end

    def call
      distance = Levenshtein.distance(full_downcase(@correct_translation),
                                      full_downcase(@provided_translation))

      sm_hash = SuperMemo.algorithm(
        @interval, @repeat, @efactor, @attempt, distance, 1
      )

      if distance <= 1
        sm_hash[:review_date] = Time.zone.now + @interval.to_i.days
        sm_hash[:attempt] = 1

        { state: true, distance: distance, sm_hash: sm_hash}
      else
        sm_hash[:attempt] = [@attempt + 1, 5].min

        { state: false, distance: distance, sm_hash: sm_hash }
      end
    end
  end
end
