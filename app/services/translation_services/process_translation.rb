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

        { sm_hash: sm_hash, status: translation_status(distance) }
      else
        sm_hash[:attempt] = [@attempt + 1, 5].min

        { sm_hash: sm_hash, status: :wrong }
      end
    end

    private

    def translation_status(distance)
      return :correct if distance == 0
      return :wrong if distance > 1

      :misspelled
    end
  end
end
