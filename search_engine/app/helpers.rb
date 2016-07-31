module Helpers
  def output_result(field, query, ignore_whitespace=false)
    words = query.split(" ")
    string = boldify_string(field, words, ignore_whitespace)
  end

  def boldify_string(string, words, ignore_whitespace)
    word = words.pop
    whitespace = /./ unless ignore_whitespace
    new_string = string.gsub(/#{word}#{whitespace}/i) { |s| "<span>#{s}</span>" }
    words.empty? ? new_string : boldify_string(new_string, words, ignore_whitespace)
  end

  def r_css(row, field=nil)
    underscore = field.nil? ? "" : "_"
    "result_#{row.id}#{underscore}#{field.to_s}"
  end
end
