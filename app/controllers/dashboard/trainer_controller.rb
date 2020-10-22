class Dashboard::TrainerController < Dashboard::BaseController
  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      @card = cards.pending.randomly.first || cards.repeating.randomly.first
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def review_card
    @card = current_user.cards.find(params[:card_id])

    payload = TranslationServices::ProcessTranslation.new(
      interval: @card.interval, repeat: @card.repeat, efactor: @card.efactor,
      attempt: @card.attempt, correct_translation: @card.translated_text,
      provided_translation: trainer_params[:user_translation]
    ).call

    @card.update(payload[:sm_hash])

    case payload[:status]
    when :correct
      flash[:notice] = t(:correct_translation_notice)
      redirect_to trainer_path
    when :misspelled
      flash[:alert] = t('translation_from_misprint_alert',
                    user_translation: trainer_params[:user_translation],
                    original_text: @card.original_text,
                    translated_text: @card.translated_text)
      redirect_to trainer_path
    when :wrong
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: @card.id)
    end
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end

  def cards
    return current_user.cards unless current_user.current_block.present?

    current_user.current_block.cards
  end
end
