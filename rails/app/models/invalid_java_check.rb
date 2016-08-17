class InvalidJavaCheck

  def issue_title
    "Invalid Java"
  end

  def issue_message
    <<-eos.squish
It looks like your code won't compile du to a bug in <FILE>, could you take
another look at it? Thanks 🙂👌
    eos
  end

  def initialize(repo)
    @repo = repo
  end

  def passed
    @passed ||= begin
      false
    end
  end

  def check
    java_files = Dir.glob "#{@repo.local_dir}/**/*.java"
    java_files.each 

  end

end
