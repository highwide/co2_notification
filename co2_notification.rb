#! /usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

CO2_LIMIT = 1000
WEBHOOK_URL = URI.parse(ENV.fetch("SLACK_WEBHOOK_URL"))

def notify_slack(msg)
  Net::HTTP.post(WEBHOOK_URL, {text: msg}.to_json )
end

begin
  co2 = JSON.parse(`sudo python3 -m mh_z19`).to_h['co2']
rescue => e
  result = notify_slack(e.message)
  raise e
end

notify_slack("書斎の二酸化炭素濃度が#{CO2_LIMIT}ppmを超えました: 現在【#{co2}ppm】") if co2 > CO2_LIMIT

puts co2
