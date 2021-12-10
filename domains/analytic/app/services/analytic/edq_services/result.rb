module Analytic
  module EdqServices
    class ResultError < StandardError; end
    class Result
      include Pagy::Backend

      PER_PAGE = 20

      def initialize(params, current_user_id = nil)
        @imo = params[:imo]
        @ballast_voyage_port_dept_id = params[:ballast_voyage_port_dept_id]
        @ballast_voyage_port_arrival_id = params[:ballast_voyage_port_arrival_id]
        @laden_voyage_port_dept_id = params[:laden_voyage_port_dept_id]
        @laden_voyage_port_arrival_id = params[:laden_voyage_port_arrival_id]
        @voyage_no = params[:voyage_no]
        @voyage_no_type = params[:voyage_no_type]
        @master_route_id = params[:master_route_id]
        @master_route_type = params[:master_route_type]
        @sort_by = params[:sort_by]
        @sort_order = params[:sort_order]
        @params = params
      end

      def fetch
        pagy, results = pagy(edq_results, items: PER_PAGE)
        return pagy, results
      end

      private
      def edq_results
        @edq_results ||= begin
          scope = Analytic::EdqResult.select(select_fields)
                                     .join_laden_voyage
                                     .join_ballast_voyage
                                     .join_user_updated_by
                                     .joins(:vessel)
                                     .includes(laden_voyage: [:port_arrival, :port_dept, :master_route],
                                               ballast_voyage: [:port_arrival, :port_dept, :master_route])

          scope = scope.where(imo: @imo) if @imo.present?
          scope = scope.where(ballast_voyage: { port_dept_id: @ballast_voyage_port_dept_id }) if @ballast_voyage_port_dept_id.present?
          scope = scope.where(ballast_voyage: { port_arrival_id: @ballast_voyage_port_arrival_id }) if @ballast_voyage_port_arrival_id.present?
          scope = scope.where(laden_voyage: { port_dept_id: @laden_voyage_port_dept_id }) if @laden_voyage_port_dept_id.present?
          scope = scope.where(laden_voyage: { port_arrival_id: @laden_voyage_port_arrival_id }) if @laden_voyage_port_arrival_id.present?
          scope = scope.where(where_clause_voyage_no) if @voyage_no.present?
          scope = scope.where(where_clause_master_route) if @master_route_id.present?
          scope.order(order_params)
        end
      end

      def select_fields
        <<~SQL
          analytic_edq_results.*,
          vessels.name as vessel_name,
          updated_by.fullname as updated_by_name
        SQL
      end

      def where_clause_voyage_no
        if @voyage_no_type.present?
          field = "#{voyage_type_field(@voyage_no_type)}_no"
          return { field => @voyage_no }
        end

        query = "analytic_edq_results.ballast_voyage_no = :voyage_no OR analytic_edq_results.laden_voyage_no = :voyage_no"
        return [ query ,{ voyage_no: @voyage_no } ]
      end

      def where_clause_master_route
        if @master_route_type.present?
          field = voyage_type_field(@master_route_type)
          return { field => { master_route_id: @master_route_id } }
        end

        query = "ballast_voyage.master_route_id = :master_route_id OR laden_voyage.master_route_id = :master_route_id"
        return [ query, { master_route_id: @master_route_id } ]
      end

      def voyage_type_field(type)
        allows_field = { l: 'laden_voyage',
                         b: 'ballast_voyage' }
        field = allows_field[type.to_s.downcase.to_sym]
        return field if field.present?

        raise ResultError, "Unknown voyage type: #{type}"
      end


      def order_params
        default = { sort_by_parser => sort_order_parser }
      end

      def sort_by_parser
        allow_sort_fields = { 'name' => 'name',
                              'vessel_name' => 'vessels.name',
                              'updated_at' =>  'updated_at',
                              'created_at' =>  'created_at',
                              'laden_voyage_no' =>  'laden_voyage_no',
                              'ballast_voyage_no' => 'ballast_voyage_no',
                              'init_lng_volume' => 'init_lng_volume',
                              'cosuming_lng_of_laden_voyage' => 'cosuming_lng_of_laden_voyage',
                              'heel' => 'heel',
                              'edq' => 'edq',
                              'unpumpable' => 'unpumpable',
                              'updated_by_name' => 'updated_by.fullname',
                              'laden_voyage_port_dept' => 'laden_voyage_port_dept.name',
                              'laden_voyage_port_arrival' => 'laden_voyage_port_arrival.name',
                              'ballast_voyage_port_arrival' => 'ballast_voyage_port_arrival.name',
                              'ballast_voyage_port_dept' => 'ballast_voyage_port_dept.name',
                              'id' => 'id'
                            }
        allow_sort_fields.fetch(@sort_by, 'id')
      end

      def sort_order_parser
        @sort_order == 'asc' ? :asc : :desc
      end

      attr_reader :params
    end
  end
end
