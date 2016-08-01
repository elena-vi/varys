module Helpers
  # highlights all words that match the search query.
  # output_result acts as a recursion wrapper:
  # boldify_string will be called until the words array
  # is empty, and the string will be manipulated once more
  # each time.
  def output_result(field, query, ignore_whitespace=false)
    words = query.split(" ")
    string = boldify_string(field, words, ignore_whitespace)
  end

  def boldify_string(string, words, ignore_whitespace)
    word = words.pop
    # . is equal to any whitespace or special characters
    whitespace = /./ unless ignore_whitespace
    # replace all matches for the word with itself but surrounded with span tags
    new_string = string.gsub(/#{word}#{whitespace}/i) { |s| "<span>#{s}</span>" }
    # if there are no more words then return the finished string otherwise pass
    # the array (minus what has just been popped off) and the new string back into
    # this function until all words have been popped.
    words.empty? ? new_string : boldify_string(new_string, words, ignore_whitespace)
  end

  # returns a prefixed html identifier specific to a row in the database
  def r_css(row, field=nil)
    underscore = field.nil? ? "" : "_"
    "result_#{row.id}#{underscore}#{field.to_s}"
  end
end
