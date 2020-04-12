require "./header"

module MQTT
  module V3
    # Class representing an MQTT Connect Acknowledgment Packet
    class Connack < BinData
      endian big

      custom header : Header = Header.new

      bit_field do
        bits 7, :_reserved_
        bool session_present
      end

      # The return code (defaults to 0 for connection accepted)
      uint8 :return_code

      delegate :id, :id=, :duplicate, :duplicate=, to: @header
      delegate :qos, :qos?, :qos=, :retain, :retain=, to: @header

      def packet_length : UInt32
        2_u32
      end

      REFUSAL_CODES = {
        1_u8 => "Connection refused: unacceptable protocol version",
        2_u8 => "Connection refused: client identifier rejected",
        3_u8 => "Connection refused: server unavailable",
        4_u8 => "Connection refused: bad user name or password",
        5_u8 => "Connection refused: not authorised",
      }

      def success?
        return_code == 0_u8
      end

      def success!
        return true if success?
        raise (REFUSAL_CODES[return_code]? || "Connection refused: error code #{return_code}")
      end
    end
  end # V3
end   # MQTT