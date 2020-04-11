require "spec"
require "../src/mqtt"

def combine(*args)
  io = IO::Memory.new
  args.each do |part|
    io.write(part.to_slice)
  end
  io.rewind
  io
end

def new_publish_packet
  packet = MQTT::V3::Publish.new
  packet.header.id = MQTT::RequestType::Publish
  packet
end

def new_connect_packet(version : MQTT::Version, client_id : String)
  packet = MQTT::V3::Connect.new
  packet.header.id = MQTT::RequestType::Connect
  case version
  when MQTT::Version::V31
    packet.version = MQTT::Version::V31
    packet.name = packet.version.connect_name
  when MQTT::Version::V311
    # This is the default
  when MQTT::Version::V5
    raise "currently unsupported"
  end
  packet.client_id = client_id
  packet.clean_start = true
  packet.keep_alive_seconds = 15
  packet
end