module Wyqs
  class Base 
    def initialize(options)
      options.each_pair do |key, value|
        self.try("#{key}=", value)
      end
    end
  end
end
