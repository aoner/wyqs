require 'json'
module Wyqs
  class Token
    attr_reader :appid, :appsecret, :requestsecret, :requesttoken

    def initialize(appid = Wyqs.appid, appsecret = Wyqs.appsecret)
      @appid = appid
      @appsecret = appsecret
    end
    
    def get_request_token(options = {})
      params = {
        :timestamp => Time.now.to_i.to_s,
        :format => 'json',
        :appid => @appid,
        :authvers => '1.0',
        :signmethod => 'md5',
        :site => 'http://routeapitest.5173.com:14167/request.do'
      }
      params.merge!(options)
      str = [params[:appid],params[:authvers],params[:format],params[:signmethod],params[:timestamp]].join("&")
      params["sign"] = encrypt(str,appsecret,requesttoken)
      res = Net::HTTP.post_form(URI(params[:site]), params)
      #if params[:format] == 'json'
      req = JSON.parse(res.body)
      @requestsecret = req["BizResult"]["RequestSecret"]
      @requesttoken = req["BizResult"]["RequestToken"]
      
      param = {
        :timestamp => Time.now.to_i.to_s,
        :format => 'json',
        :appid => @appid,
        :authvers => '1.0',
        :signmethod => 'md5',
        :requesttoken => @requesttoken,
        :site => 'http://routeapitest.5173.com:14167/access.do'
      }
      accessstr = [param[:appid],param[:authvers],param[:format],param[:requesttoken],param[:signmethod],param[:timestamp]].join("&")
      param["sign"] = encrypt(accessstr,appsecret,@requestsecret)
      ress = Net::HTTP.post_form(URI(param[:site]), param)
      JSON.parse(ress.body)
      #else
      #  res.body
      #end
    end
    
    private
    def encrypt(signatureBase, appsecret, tokensecret)
      basestr = Digest::MD5.hexdigest(signatureBase).downcase
      URI.encode(Base64.encode64s([appsecret,basestr,tokensecret].join("&")))
    end
  end
end
