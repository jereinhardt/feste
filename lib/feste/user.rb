module Feste
  module User
    def email_source
      send(Feste.options[:email_source])
    end
  end
end