module RubyLs
  class Application

  	def initialize(argv)
      @params, @args = parse_options(argv)
      @dir = @args.first
      @display = RubyLs::Display.new(@params)
  	end

  	def run
      begin
  	    if @dir =~ /\./
          @display.render(@args, directory?)        
  	    elsif @dir
  	    	Dir.chdir("#{@dir}")
  	    	@display.render(files, directory?)
  	    else
  	    	@display.render(files, directory?)
  	    end
      rescue SystemCallError => e
        abort("ls: #{@dir}: No such file or directory")
      end
  	end

    private

      def parse_options(argv)
        params = {}
        parser = OptionParser.new
        parser.on("-l") {params[:detail] = true}
        parser.on("-a") {params[:hidden] = true}
        begin
          dir = parser.parse(argv)
        rescue OptionParser::InvalidOption => e 
          invalid_flag = e.message[/invalid option: -(.*)/, 1]
          abort "ls: illegal option -- #{invalid_flag}\n"+
          "usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]"
        end
        [params, dir]
      end

      def files
        @params[:hidden] ? Dir.entries(".") : Dir.glob("*")
      end

      def directory?
        @args.empty? || (@args.count == 1 && File.directory?(@args.first))
      end

  end
end