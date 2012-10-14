module Wyqs
  class Consumer
    attr_accessor :appid, :appsecret, :accesstoken, :accesssecret

    def initialize(appid = Wyqs.appid, appsecret = Wyqs.appsecret)
      @appid = appid
      @appsecret = appsecret
      a = Token.new(appid,appsecret).get_request_token
      @accesstoken = a["BizResult"]["AccessToken"]
      @accesssecret = a["BizResult"]["AccessSecret"]
    end
    
    def list
        params = {
        :accesstoken => @accesstoken,
        :appid => @appid,
        :authvers => '1.0',
        :clientip => '127.0.0.1',
        :fields => '',
        :format => 'json',
        :method => 'kubao.passport.display',
        :parainfo => {"IsDisplayHeadRear"=>true,"IsSupportPasspod"=>true,"CallbackUrl"=>"http://thirdpart.com/welcome.aspx"},
        :signmethod => 'md5',
        :timestamp => Time.now.to_i.to_s,
        :vers => '1.0',
        :token => ""
        }
        
        baseSign =[@accesstoken,@appid,params[:authvers],params[:clientip],params[:fields],params[:format],params[:method],params[:parainfo],params[:signmethod],params[:timestamp],params[:token],"GET:http://routeapitest.5173.com:14167/rest.do",params[:vers]].join("&")
        puts baseSign
      params[:sign] = encrypt(baseSign,appsecret,accesssecret)
      puts params
      ress = Net::HTTP.post_form(URI("http://routeapitest.5173.com:14167/rest.do"), params)
      JSON.parse(ress.body)
    end
    
    private
    def encrypt(signatureBase, appsecret, tokensecret)
      basestr = Digest::MD5.hexdigest(signatureBase).downcase
      puts [basestr,appsecret,tokensecret].join("&")
      URI.encode(Base64.encode64s([basestr,appsecret,tokensecret].join("&")))
    end
  end
end
