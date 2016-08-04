module Helpers
  def output_result(field, query)
    words = query.split(" ")
    string = boldify_string(field, words)
  end

  def boldify_string(string, words)
    word = words.pop
    string.gsub!(/#{word}/i) { |s| "<span>#{s}</span>" } if string != ""
    words.empty? ? string : boldify_string(string, words)
  end

  def r_css(row, field=nil)
    underscore = field.nil? ? "" : "_"
    "result_#{row.id}#{underscore}#{field.to_s}"
  end

  def get_pages(result_count, current_start)
    number_of_pages = result_count / 10
    pages_array = []
    (1..number_of_pages).each { |i| pages_array << i }
    pages_array << (number_of_pages + 1) if result_count % 10 != 0

    current_page = (current_start / 10)

    if current_page < 4
      return pages_array[0, 10]
    else
      # page is 8 so show 9 to 17
      return pages_array[current_page-1, current_page+6]
    end
  end

  def get_start_number(page_number)
    (page_number - 1) * 10
  end

  def pluralise(word, count)
    count != 1 ? word + 's' : word
  end

  def k_to_c(kelvin)
    "#{(kelvin - 273.15).round(1)} &#176;C"
  end
end
