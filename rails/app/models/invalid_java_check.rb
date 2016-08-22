class InvalidJavaCheck

  def issue_title
    "Invalid Java"
  end

  def issue_message
    "It looks like your code won't compile! 😧" 
  end

  def initialize(dir)
    @dir = dir
  end

  def passes?
    Dir.glob("#{@dir}/**/*.java").all? do |file|
      Rails.logger.info "Running check `java io.evabot.IsValidJavaCheck #{file}`"
      system "java", "io.evabot.IsValidJavaCheck", file
    end
  end

end
