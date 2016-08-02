module Helpers
  def output_result(field, query, ignore_whitespace=false)
    words = query.split(" ")
    string = boldify_string(field, words, ignore_whitespace)
  end

  def boldify_string(string, words, ignore_whitespace)
    word = words.pop
    whitespace = /./ unless ignore_whitespace
    new_string = string ? string.gsub(/#{word}#{whitespace}/i) { |s| "<span>#{s}</span>" } : ""
    words.empty? ? new_string : boldify_string(new_string, words, ignore_whitespace)
  end

  def r_css(row, field=nil)
    underscore = field.nil? ? "" : "_"
    "result_#{row.id}#{underscore}#{field.to_s}"
  end

  def get_pages_wrapper(query, start_point)
    pages_array = [1]
    get_pages(query, pages_array, start_point)
  end

  def get_pages(query, pages_array, start_point)
    sp = (start_point.to_i + 10)

    if Webpage.do_search(query, sp).length > 0
      pages_array << (pages_array.last + 1)
      get_pages(query, pages_array, sp)
    else
      return pages_array
    end
  end

  def get_start_number(page_number)
    (page_number - 1) * 10
  end

  def pluralise(word, count)
    count != 1 ? word + 's' : word
  end

end
