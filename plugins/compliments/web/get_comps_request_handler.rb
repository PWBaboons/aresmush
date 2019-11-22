module AresMUSH
  module Compliments
    class GetCompsRequestHandler
      attr_accessor :comps

      def handle(request)
        filter = request.args[:filter]
        page = (request.args[:page] || "1").to_i
        char = Character.find_one_by_name request.args[:char_id]
        enactor = request.enactor
        puts "REQUEST ARGS #{request.args}"

        def get_comps(list)
          list = list.to_a.sort_by { |c| c.created_at }.reverse
          list.map { |c|
            {
              from: c.from,
              msg:  Website.format_markdown_for_html(c.comp_msg),
              date: OOCTime.format_date_for_entry(c.created_at)
            }}
        end

        if (filter == "Recent")
          comps = get_comps(char.comps)[0...10]
          puts "RECENT"
        else
          comps = get_comps(char.comps)
        end

        comps_per_page = 30
        paginator = Paginator.paginate(comps, page, comps_per_page)

        if (paginator.out_of_bounds?)
          return { comps: [], pages: [1] }
        end

        puts "#{comps}"

        {
          comps: paginator.page_items,
          pages: paginator.total_pages.times.to_a.map { |i| i+1 }

        }
      end

    end
  end
end
