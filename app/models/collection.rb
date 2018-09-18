class Collection < ApplicationRecord
  has_many :ceramiques
  has_attachments :photos, dependent: :destroy

  include AlgoliaSearch

  algoliasearch do
    add_attribute :translated_name_fr
    add_attribute :translated_name_en
    add_attribute :translated_description_fr
    add_attribute :translated_description_en
    attribute :name
  end

  extend Mobility
  translates :name, type: :string, fallbacks: { fr: :en, en: :fr }, locale_accessors: [:en, :fr]
  translates :description, type: :text, fallbacks: { fr: :en, en: :fr }, locale_accessors: [:en, :fr]

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true
  validates :photos, presence: true

  def to_param
    name_param = self.send(I18n.locale == :fr ? (name_fr.present? ? "name_fr" : (name_en.present? ? "name_en" : "name")) : (name_en.present? ? "name_en" : "name")) || ""
    [id, name_param.parameterize].join("-")
  end

  def translated_name_fr
    self.name_fr
  end

  def translated_name_en
    self.name_en
  end

  def translated_description_fr
    self.description_fr
  end

  def translated_description_en
    self.description_en
  end
end