require 'rails_helper'

RSpec.describe TranslationServices::ProcessTranslation, type: :model do
  it 'check_translation Eng OK' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'house'
    ).call

    expect(check_result[:status]).to be :correct
  end

  it 'check_translation Eng NOT' do
    card = Card.create(original_text: 'дом', translated_text: 'house',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'RoR'
    ).call

    expect(check_result[:status]).to be :wrong
  end

  it 'check_translation Rus OK' do
    card = Card.create(original_text: 'house', translated_text: 'дом',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'дом'
    ).call

    expect(check_result[:status]).to be :correct
  end

  it 'check_translation Rus NOT' do
    card = Card.create(original_text: 'house', translated_text: 'дом',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'RoR'
    ).call

    expect(check_result[:status]).to be :wrong
  end

  it 'check_translation full_downcase Eng OK' do
    card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'HouSe'
    ).call

    expect(check_result[:status]).to be :correct
  end

  it 'check_translation full_downcase Eng NOT' do
    card = Card.create(original_text: 'ДоМ', translated_text: 'hOuSe',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'RoR'
    ).call

    expect(check_result[:status]).to be :wrong
  end

  it 'check_translation full_downcase Rus OK' do
    card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'дОм'
    ).call

    expect(check_result[:status]).to be :correct
  end

  it 'check_translation full_downcase Rus NOT' do
    card = Card.create(original_text: 'hOuSe', translated_text: 'ДоМ',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'RoR'
    ).call

    expect(check_result[:status]).to be :wrong
  end

  it 'check_translation Eng OK levenshtein_distance' do
    card = Card.create(original_text: 'дом', translated_text: 'hous',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'house'
    ).call

    expect(check_result[:status]).to be :misspelled
  end

  it 'check_translation Rus OK levenshtein_distance' do
    card = Card.create(original_text: 'house', translated_text: 'до',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'дом'
    ).call

    expect(check_result[:status]).to be :misspelled
  end

  it 'check_translation Eng NOT levenshtein_distance=2' do
    card = Card.create(original_text: 'дом', translated_text: 'hou',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'RoR'
    ).call

    expect(check_result[:status]).to be :wrong
  end

  it 'check_translation Rus NOT levenshtein_distance=2' do
    card = Card.create(original_text: 'house', translated_text: 'д',
                       user_id: 1, block_id: 1)

    check_result = TranslationServices::ProcessTranslation.new(
      interval: card.interval, repeat: card.repeat, efactor: card.efactor,
      attempt: card.attempt, correct_translation: card.translated_text,
      provided_translation: 'RoR'
    ).call

    expect(check_result[:status]).to be :wrong
  end
end
