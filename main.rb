require "net/https"
require "json"

gh_token     = ENV['github_token']
github_repo  = ENV['github_repo']
release_name = "#{ENV['BITRISE_TRIGGERED_WORKFLOW_TITLE']}_#{ENV['release_name']}"

release_desc = ""
commit = `git rev-parse HEAD | xargs echo -n`

uri = URI("https://api.github.com")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new("/repos/#{github_repo}/releases")
request["Accept"] = "application/vnd.github.manifold-preview"
request["Authorization"] = "token #{gh_token}"
request.body = {
  "tag_name"         => release_name,
  "target_commitish" => commit,
  "name"             => release_name,
  "body"             => release_desc,
  "draft"            => false,
  "prerelease"       => false,
}.to_json

puts github_repo
puts request.body

response = http.request(request)
abort response.body unless response.is_a?(Net::HTTPSuccess)

release = JSON.parse(response.body)
puts release["html_url"]

`envman add --key RELEASE_URL --value #{release["html_url"]}`