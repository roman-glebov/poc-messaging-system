#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

if ARGV.empty?
  abort 'Usage: #{$0} [binding key]'
end

conn = Bunny.new
conn.start

ch  = conn.create_channel
x   = ch.topic('amq.topic')
q   = ch.queue('project_log')

ARGV.each do |severity|
  q.bind(x, :routing_key => severity)
end

puts ' [*] Waiting for logs. To exit press CTRL+C'

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] #{delivery_info.routing_key}:#{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close
end
