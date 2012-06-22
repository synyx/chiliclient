require 'net/http'
require 'net/https'
require 'json'
require 'yaml'
require 'highline/import'

module ChiliClient

  def self.get_issues(site, user, password, limit=100)

    uri = URI(site + "/issues.json?limit=#{limit}")

    json_get(uri, user, password)
  end

  def self.get_safed_query(site, user, password, query_id, limit=100)

    uri = URI(site + "/issues.json?limit=#{limit}&query_id=#{query_id}")

    json_get(uri, user, password)
  end

  def self.json_get(uri, user, password)
    http = Net::HTTP.new(uri.host, uri.port)

    if uri.instance_of? URI::HTTPS
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth user, password

    res = http.request(req)

    JSON.parse res.body
  end
end
