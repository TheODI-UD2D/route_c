module RouteC
  class Config

    def initialize
      config.each do |k,v|
        self.class.send(:define_method, k.to_sym, Proc.new { return v })
      end
    end

    def config
      YAML.load_file(config_path)
    end

    def config_path
      File.exists?("#{user_dir}/config.yaml") ? "#{user_dir}/config.yaml" : "#{gem_dir}/config.yaml"
    end

    def user_dir
      File.join('~', '.routec')
    end

    def gem_dir
      File.join('.', 'config')
    end

  end
end
