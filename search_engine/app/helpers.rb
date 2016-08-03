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

  # da faq is this?
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

  def ellipsis(field)
    "..." if field.length >= 110
  end

end
