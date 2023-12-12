module AutoBooker
  class PreferencesLeoader
    def self.load(content)
      content.map do |item|
        Preference.new(
          weekday: item['weekday'],
          hour: item['hour'],
          minutes: item['minutes']
        )
      end
    end

    def self.from_yaml_file(yaml_file)
      content = YAML.load_file(yaml_file)
      self.load(content)
    end
  end
end