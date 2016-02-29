module RouteC
  class Config

    def initialize
      @config = fetch_yaml "#{gem_dir}/config.yaml"

      if File.exists? "#{user_dir}/config.yaml"
        @local = fetch_yaml "#{user_dir}/config.yaml"
        @config.merge! @local
      end

      @config.each do |k,v|
        self.class.send(:define_method, k.to_sym, Proc.new { return v })
      end
    end

    def fetch_yaml file
      YAML.load_file file
    end

    def user_dir
      File.join(ENV['HOME'], '.routec')
    end

    def gem_dir
      File.join(File.dirname(__FILE__), '..', '..', 'config')
    end

  end
end
