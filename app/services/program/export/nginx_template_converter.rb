class Program
  module Export
    class NginxTemplateConverter

      IP_ADDRESSES_REGEXP = /<ip_addresses>\.each\s*{(?<value>((\\\})|[^\}])*)}/

      def initialize(ip_addresses, ip_port, uniq_section_name)
        @ip_addresses = ip_addresses
        @ip_port = ip_port
        @uniq_section_name = uniq_section_name
      end

      def conver(src_str)
        result = convert_ip_addresses(src_str)
        result = convert_uniq_section_name(result)
        result = convert_ip_port(result)
      end

      def convert_uniq_section_name(src_str)
        src_str.gsub(/<uniq_section_name>/, @uniq_section_name)
      end

      def convert_ip_address(src_str, ip_address)
        src_str.gsub(/<ip_address>/, ip_address)
      end

      def convert_ip_port(src_str)
        src_str.gsub(/<ip_port>/, @ip_port)
      end

      def convert_ip_addresses(src_str)
        src_str =~ IP_ADDRESSES_REGEXP
        while Regexp.last_match do
          template = Regexp.last_match[:value]
          result = ''
          @ip_addresses.each do |ip_address|
            result += convert_address_and_port(template, ip_address)
          end
          src_str = src_str.sub(IP_ADDRESSES_REGEXP, result)
          src_str =~ IP_ADDRESSES_REGEXP
        end
        src_str
      end

      private
        attr_accessor :ip_addresses, :ip_port, :uniq_section_name

        def convert_address_and_port(src_str, ip_address)
          src_str = convert_ip_address(src_str, ip_address)
          convert_ip_port(src_str)
        end
    end
  end
end