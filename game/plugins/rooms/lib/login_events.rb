module AresMUSH
  module Rooms
    class LoginEvents
      include Plugin

      def on_char_connected_event(event)
        client = event.client
        Rooms.emit_here_desc(client)
      end
      
      def on_char_disconnected_event(event)
        client = event.client
        if (client.char.has_role?("guest"))
          Rooms.move_to(client, client.char, Game.master.welcome_room)
        end
      end
      
    end
  end
end
