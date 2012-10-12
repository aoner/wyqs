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
        parsm = {
        :appid => @appid,
        :authvers => '1.0',
        :format => 'json',
        :signmethod => 'md5',
        :timestamp => Time.now.to_i.to_s,
        :accesstoken => @accesstoken,
        :token => "",
        :returnurl => 'http://thirdpart.com/welcome.aspx',
        :parainfo => {"IsDisplayHeadRear"=>true,"IsSupportPasspod"=>true,"CallbackUrl"=>'http://5433.com'},
        :vers => '1.0',
        :clientip => '127.0.0.1',
        :fields => '',
        :method => 'kubao.trade.BasicType.get',
        :uri => 'GET:#{requesturi}',
        :requesturi = 'http://routeapitest.5173.com:14167/rest.do?'
        }

        baseSign =[@accesstoken,@appid,params[:authvers],params[:clientip],params[:fields],params[:format],params[:method],params[:parainfo],params[:signmethod],params[:timestamp],params[:token],params[:uri],params[:vers]].join("&")
      sign = encrypt(baseSign,appsecret,accesssecret)
      puts address
      ress = Net::HTTP.post_form(URI("http://routeapitest.5173.com:14167/rest.do?"), param)
      JSON.parse(ress.body)
    end
    
    private
    def encrypt(signatureBase, appsecret, tokensecret)
      basestr = Digest::MD5.hexdigest(signatureBase).downcase
      puts basestr
      puts [appsecret,basestr,tokensecret].join("&")
      URI.encode(Base64.encode64s([appsecret,basestr,tokensecret].join("&")))
    end
  end
end
