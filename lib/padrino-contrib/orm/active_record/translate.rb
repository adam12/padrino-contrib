module Padrino
  module Contrib
    module Orm
      module ActiveRecord
        ##
        # This is an extension for ActiveRecord where if I had:
        #
        #   post.description_ru = "I'm Russian"
        #   post.description_en = "I'm English"
        #   post.description_it = "I'm Italian"
        #
        # with this extension if I had set:
        #
        #   I18n.locale = :it
        #
        # calling directly:
        #
        #   post.description
        #
        # will be a shortcut for:
        #
        #  post.description_it => "I'm Italian"
        #
        # if post_description_fr don't exist, now return
        # the default translate (with I18n.default_locale)
        #
        module Translate
          module ClassMethods
            def has_locale
              include InstanceMethods
            end
          end # ClassMethods

          module InstanceMethods
            def method_missing(method_name, *arguments)
              attribute = "#{method_name}_#{I18n.locale}".to_sym
              return self.send(attribute) if I18n.locale.present? && self.respond_to?(attribute)
              attribute_default = "#{method_name}_#{I18n.default_locale}"
              return self.send(attribute_default) if I18n.default_locale.present? && self.respond_to?(attribute_default)
              super
            end
          end # InstanceMethods
        end # Translate
      end # ActiveRecord
    end # Orm
  end # Contrib
end # Padrino
::ActiveRecord::Base.extend(Padrino::Contrib::Orm::ActiveRecord::Translate::ClassMethods)
