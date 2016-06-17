module Octicons
  class Octicon

    attr_reader :path, :html_options, :width, :height

    def initialize(options)
      @options = options
      if symbol = Octicons::OCTICON_SYMBOLS[@options[:symbol]]
        @path = symbol[:path]
        @width = symbol[:width]
        @height = symbol[:height]

        # create html_options from options, except for a few
        @html_options = @options.reject { |d| [:symbol].include? d }
        @html_options.merge!({
          :class   => classes,
          :viewBox => viewbox,
          :version => "1.1"
        })
        @html_options.merge!(size)
        @html_options.merge!(a11y)
      else
        raise "Couldn't find octicon symbol for #{options[:symbol].inspect}"
      end
    end

    # Returns an string representing a <svg> tag
    def to_svg
      "<svg #{html_attributes}>#{@path}</svg>"
    end

    # Returns an array of keywords similar to the icon
    def keywords
      Octicons::KEYWORDS[@options[:symbol]]["keywords"]
    end

    # Returns the decimal codepoint of the character
    def decimal
      Octicons::CODEPOINTS[@options[:symbol]]
    end

    # Returns the hexidecimal version of the character
    def hexadecimal
      decimal.to_s(16)
    end

    # Returns the unicode character
    def character
      [decimal].pack("U")
    end

    private

    def html_attributes
      attrs = ""
      @html_options.each { |attr, value| attrs += "#{attr}=\"#{value}\" " }
      attrs.strip
    end

    # add some accessibility features to svg
    def a11y
      accessible = {}

      if @options[:'aria-label'].nil?
        accessible[:'aria-hidden'] = "true"
      else
        accessible[:role] = "img"
      end

      accessible
    end

    # prepare the octicon class
    def classes
      "octicon octicon-#{@options[:symbol]} #{@options[:class]} ".strip
    end

    def viewbox
      "0 0 #{@width} #{@height}"
    end

    # determine the height and width of the octicon based on :size option
    def size
      size = {
        :width => @width,
        :height => @height
      }

      # Specific size
      unless @options[:width].nil? && @options[:height].nil?
        size[:width]  = @options[:width].nil?  ? calculate_width(@options[:height]) : @options[:width]
        size[:height] = @options[:height].nil? ? calculate_height(@options[:width]) : @options[:height]
      end

      size
    end

    def calculate_width(height)
      (height.to_i * @width) / @height
    end

    def calculate_height(width)
      (width.to_i * @height) / @width
    end
  end
end
