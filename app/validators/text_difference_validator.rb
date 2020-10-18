class TextDifferenceValidator < ActiveModel::Validator
  include StringFormatter

  def validate(record)
    record.errors[:original_text] << 'Вводимые значения должны отличаться.' if texts_eql?(record)
  end

  private

  def texts_eql?(record)
    full_downcase(record.original_text) == full_downcase(record.translated_text)
  end
end
