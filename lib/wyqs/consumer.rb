module Wyqs
  class Consumer
    attr_accessor :accesstoken, :accesssecret

    def initialize(appid = Wyqs.appid, appsecret = Wyqs.appsecret)
      @appid = appid
      @appsecret = appsecret
      a = Token.new(appid,appsecret).get_request_token
      @accesstoken = a["BizResult"]["AccessToken"]
      @accesssecret = a["BizResult"]["AccessSecret"]
    end
    
    def list
        appid = @appid
        authvers = '1.0'
        format = 'json'
        signmethod = 'md5'
        timestamp = Time.now.to_i.to_s
        accesstoken = @accesstoken
        token = ""
        returnurl = 'http://thirdpart.com/welcome.aspx'
        parainfo = {"IsDisplayHeadRear"=>true,"IsSupportPasspod"=>true,"CallbackUrl"=>'http://5433.com'}
        vers = '1.0'
        clientip = '127.0.0.1'
        fields = ''
        method = 'kubao.trade.BasicType.get'
        uri = 'GET:#{requesturi}'
        requesturi = 'http://5433.com' 

        baseSign =[accesstoken,appid,authvers,clientip,fields,format,method,parainfo,signmethod,timestamp,token,uri,vers].join("&")
      sign = encrypt(baseSign,appsecret,accesssecret)
      address = '#{requesturi}?#accesstoken=#{accesstoken}&appid=#{appid}&authvers=#{authvers}&clientip=#{clientip}&fields=#{fields}&format=#{format}&method=#{method}&parainfo=#{parainfo}&signmethod=#{signmethod}&timestamp=#{timestamp}&vers=#{vers]&token=#{token}&sign=#{sign}'
      puts address
      redirect_to(address)
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
