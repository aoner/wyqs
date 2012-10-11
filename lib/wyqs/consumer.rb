module Wyqs
  class Consumer
    attr_accessor :accesstoken, :accesssecret

    def initialize(appid = Wyqs.appid, appsecret = Wyqs.appsecret)
      @appid = appid
      @appsecret = appsecret
      a = Token.new(appid,appsecret).get_request_token
      accesstoken = a["BizResult"]["AccessToken"]
      accesssecret = a["BizResult"]["AccessSecret"]
    end
  end
end
