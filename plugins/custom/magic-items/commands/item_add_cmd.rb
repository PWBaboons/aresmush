module AresMUSH
  module Custom
    class ItemAddCmd
      include CommandHandler
# item/add <name>=<item> - Give someone an item.

      attr_accessor :target, :item_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.item_name = titlecase_arg(args.arg2)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !FS3Skills.can_manage_abilities?(enactor)
      end

      def check_errors
        return t('custom.invalid_name') if !self.target
        return t('custom.not_item') if !Custom.is_item?(self.item_name)
        return nil
      end

      def handle
        #Reading Config
        name = Global.read_config("magic-items", self.item_name, "name")
        weapon_specials = Global.read_config("magic-items", self.item_name, "weapon_specials")
        armor_specials = Global.read_config("magic-items", self.item_name, "armor_specials")
        spell = Global.read_config("magic-items", self.item_name, "spell")
        desc = Global.read_config("magic-items", self.item_name, "desc")


        MagicItem.create(name: name, character: self.target, desc: desc, weapon_specials: weapon_specials, armor_specials: armor_specials, spell: spell)

        client.emit_success t('custom.added_magic_item', :item_name => name, :target => target.name)

        message = t('custom.given_magic_item', :name => enactor.name, :item_name => name)
        client.emit_success message
        Mail.send_mail([target.name], t('custom.give_magic_item_subj'), message, nil)

      end






    end
  end
end
