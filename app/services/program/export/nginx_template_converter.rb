class Program
  module Export
    class NginxTemplateConverter

      IP_ADDRESSES_REGEXP = /<ip_addresses>\.each\s*{(?<value>((\\\})|[^\}])*)}/
      IP_ADDRESS_REGEXP = /<ip_address>/
      IP_PORT = /<ip_port>/
      SECTION_NAME_REGEXP = /<uniq_section_name>/
      PROGRAM_TYPE_REGEXEP = /<program_type>/
      SERVER_NAME_REGEXP = /<server_name>/
      HTTP_PREFIX_REGEXP = /<http_prefix>/
      IDENT_NAME_REGEXP = /<ident_name>/


      def initialize(server_name, ip_addresses, ip_port, program)
        @ip_addresses = ip_addresses
        @ip_port = ip_port
        @program = program
        @server_name = server_name
      end

      def convert(src_str)
        result = convert_ip_addresses(src_str)
        result = convert_uniq_section_name(result)
        result = convert_ip_port(result)
        result = convert_program_type(result)
        result = convert_server_name(result)
        result = convert_http_prefix(result)
        convert_ident_name(result)
      end

      def convert_ident_name(src_str)
        src_str.gsub(IDENT_NAME_REGEXP, @program.identification_name.gsub('-','_'))
      end

      def convert_http_prefix(src_str)
        src_str.gsub(HTTP_PREFIX_REGEXP, @program.decorate.http_prefix)
      end

      def convert_server_name(src_str)
        src_str.gsub(SERVER_NAME_REGEXP, @server_name)
      end

      def convert_program_type(src_str)
        src_str.gsub(PROGRAM_TYPE_REGEXEP, @program.program_type)
      end

      def convert_uniq_section_name(src_str)
        src_str.gsub(SECTION_NAME_REGEXP, uniq_section_name)
      end

      def convert_ip_address(src_str, ip_address)
        src_str.gsub(IP_ADDRESS_REGEXP, ip_address)
      end

      def convert_ip_port(src_str)
        src_str.gsub(IP_PORT, @ip_port)
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
        attr_accessor :server_name, :ip_addresses, :ip_port, :program

        def convert_address_and_port(src_str, ip_address)
          src_str = convert_ip_address(src_str, ip_address)
          convert_ip_port(src_str)
        end

        def uniq_section_name
          "#{@program.identification_name.gsub('-','_')}_#{program.program_type}"
        end
    end
  end
end