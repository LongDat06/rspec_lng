module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class Base
          attr_reader :imo, :atd, :ata, :engine_type
          def initialize(imo, atd, ata, engine_type = nil)
            @imo = imo
            @atd = atd
            @ata = ata
            @engine_type = engine_type
          end

          def call
            Analytic::Sim.collection.aggregate([matched, group_at_time, group_day, sort, project], { allowDiskUse: true } )
          end

          protected
            def closest_time(time_value)
              sim_obj = Analytic::SimServices::ProvideClosestData.new(imo: imo, time: time_value).call
              sim_obj.spec['ts']
            end

            def matched
              {
                "$match" => {
                  "$and" => [
                    "imo_no" => imo,
                    "spec.ts" => { "$gte" => closest_time(atd), "$lte" => closest_time(ata) },
                  ]
                }
              }
            end

            def sort
              { "$sort" => { "_id" => 1 } }
            end

            def group_at_time
              {
                "$group" => {
                   "_id" => { "timestamp": "$spec.ts" },
                }.merge!(specific_group_at_time)
              }
            end
          


            def group_day
              {
                "$group" => {
                   "_id" => {"$dateToString": { format: "%Y-%m-%d", date: "$_id.timestamp", timezone: "UTC"} },
                }.merge!(specific_group_day)
              }
            end

            def project
              { 
                "$project": { 
                              average_value: "$average_value"
                            }
              }
            end

            def specific_group_at_time
              raise "specific_group_at_time can be defined in child class"
            end

            def specific_group_day
              raise "specific_group_day can be defined in child class"
            end

            def count_without_blank(field_name)
              {"$cond": [ { "$and": [ { "$ne": [field_name, "" ] },
                                      { "$ne": [field_name, nil ] }
                                    ]
                          }, 1, 0] }
            end

            def calculate_without_blank(field_name)
              {"$cond": [ { "$and": [ { "$ne": [field_name, "" ] },
                                      { "$ne": [field_name, nil ] }
                                    ]
                          }, field_name, 0] }
            end

        end
      end
    end
  end
end
