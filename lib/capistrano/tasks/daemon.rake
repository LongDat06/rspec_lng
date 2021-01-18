git_plugin = self

namespace :puma do
  desc 'Start puma'
  task :start_without_daemon do
    on roles(fetch(:puma_role)) do |role|
      git_plugin.puma_switch_user(role) do
        if test "[ -f #{fetch(:puma_pid)} ]" and test :kill, "-0 $( cat #{fetch(:puma_pid)} )"
          info 'Puma is already running'
        else
          within current_path do
            with rack_env: fetch(:puma_env) do
              execute :puma, "-C #{fetch(:puma_conf)} &"
            end
          end
        end
      end
    end
  end
end
