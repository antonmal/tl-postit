module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_field
    # adds an accessor to both class and instances,
    #   so both self.class.slug_field and self.slug_field will work
  end

  module ClassMethods
    # ex. when_to_generate = { on: [:create, :update], if: ... }
    def has_slug(field, **when_to_generate)
      self.slug_field = field
      before_save :generate_slug!, when_to_generate
    end
  end

  def to_param
    self.slug
  end

  def generate_slug!
    slug = self.send(self.slug_field).downcase
              .gsub(/\W|\_/, '-').gsub(/[\-]+/, '-')
              .gsub(/^[\-]+/, '').gsub(/[\-]+$/, '')
    i = 1
    while !!self.class.where.not(id: self.id).find_by(slug: slug) do
      i == 1 ? slug += '-1' : slug = slug.split('-')[0..-2].join('-') + "-#{i}"
      i += 1
    end
    self.slug = slug
  end
end
