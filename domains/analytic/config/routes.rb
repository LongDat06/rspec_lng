Analytic::Engine.routes.draw do
  namespace :v1 do
    namespace :charts do
      resources :stage_boil_off_rate, only: [:index]
      resources :stage_trend1, only: [:index]
      resources :stage_trend21, only: [:index]
      resources :stage_tank_volume, only: [:index]
      resources :stage_tank_equator_temp, only: [:index]
      resources :stage_tank_liquid_temp, only: [:index]
      resources :stage_press, only: [:index]
      resources :stage_trend33, only: [:index]
      resources :xdf_trend1, only: [:index]
      resources :xdf_trend21, only: [:index]
      resources :xdf_boil_off_rate, only: [:index]
      resources :xdf_tank_volume, only: [:index]
      resources :xdf_tank_liquid_temp, only: [:index]
      resources :xdf_inner_surface_temp, only: [:index]
      resources :xdf_press, only: [:index]
      resources :xdf_trend314, only: [:index]
      resources :xdf_trend315, only: [:index]
      resources :xdf_trend316, only: [:index]
      resources :xdf_trend317, only: [:index]
      resources :cm_stage_press_hold, only: [:index]
      resources :total_tank_volume, only: [:index]
      resources :em_stage_blr, only: [:index]
      resources :xdf_foc_1, only: [:index]
      resources :xdf_total_foc, only: [:index]
      resources :stage_foc1, only: [:index]
      resources :stage_total_foc, only: [:index]
      resources :xdf_me, only: [:index]
      resources :og_speed, only: [:index]
      resources :f_dump_v_open, only: [:index]
      resources :blr_flow, only: [:index]
    end

    namespace :downloads do
      resources :sims, only: [:create]
      resources :histories, only: [:index]
      resources :templates, only: [:index, :create, :destroy, :update]
    end

    resources :sim_channels, only: [:index] do
      get :fetch_units, on: :collection
    end

    namespace :vessels do
      resources :stage_specs, only: [:index]
      resources :xdf_specs,   only: [:index]
    end

    resources :datasets, only: [:index]
    namespace :voyages do
      resources :routes, only: [:index] do
        collection do
          get :fetch_first_ports
          get :fetch_second_ports
        end
      end
    end

    namespace :management do
      resources :focs do
        collection do
          post :import
          get :fetch_invalid_record_file
          get :export
        end
      end
      resources :routes, except: [:show] do
        collection do
          post :import
          get :fetch_invalid_record_file
          get :export
        end
      end
      resources :master_routes do
        get :fetch_autocomplete_routes, on: :collection
      end
      resources :master_ports do
        get :fetch_autocomplete_ports, on: :collection
      end
    end

    resources :vessels, module: :vessels, param: :imo do
      resources :genres, only: [:index, :import] do
        post 'import', on: :collection
        get 'export_mapping', on: :collection
        get 'export_errors', on: :collection
      end
    end

    post "/temp/upload", to: "temporary_upload#upload"
    mount Analytic::Uploader::TemporaryUploader.upload_endpoint(:cache) => "/temp/upload"


    namespace :heels do
      resources :calculator, only: [:create]
      resources :timezone_label, only: [:index]
    end

    namespace :edqs do
      resources :result, only: [:index, :create, :update, :show, :destroy]
    end

    namespace :masters do
      resources :countries, only: [:index]
      resources :timezones, only: [:show], param: :country_code
    end

  end
end
