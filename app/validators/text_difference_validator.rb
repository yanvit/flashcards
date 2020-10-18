class TextDifferenceValidator < ActiveModel::Validator
  include StringFormatter

  def validate(record)
    if texts_eql?(record)
      record.errors[:original_text] << 'Вводимые значения должны отличаться.'
    end
  end

  private

  def texts_eql?(record)
    full_downcase(record.original_text) == full_downcase(record.translated_text)
  end
end
