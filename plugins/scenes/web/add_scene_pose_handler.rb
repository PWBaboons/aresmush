module AresMUSH
  module Scenes
    class AddScenePoseRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        pose = (request.args[:pose] || "").chomp
        pose_type = request.args[:pose_type]
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        if (!scene.room)
          raise "Trying to pose to a scene that doesn't have a room."
        end
        
        Global.logger.debug "Scene #{scene.id} pose added by #{enactor.name}."
        
        pose = Website.format_input_for_mush(pose)
        
        parse_results = Scenes.parse_web_pose(pose, enactor, pose_type)
        
        Scenes.emit_pose(enactor, parse_results[:pose], parse_results[:is_emit], 
           parse_results[:is_ooc], nil, parse_results[:is_setpose] || parse_results[:is_gmpose], scene.room)
        
        if (parse_results[:is_setpose] && scene.room)
          scene.room.update(scene_set: parse_results[:pose])
        end
        
        {}
      end
    end
  end
end