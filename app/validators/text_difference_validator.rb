class TextDifferenceValidator < ActiveModel::Validator
  include StringFormatter

  def validate(record)
    record.errors[:original_text] << I18n.t('activerecord.errors.messages.text_difference') if texts_eql?(record)
  end

  private

  def texts_eql?(record)
    full_downcase(record.original_text) == full_downcase(record.translated_text)
  end
end
