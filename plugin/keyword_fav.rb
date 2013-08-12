# -*- encoding: utf-8 -*-
module KeywordFav
  def keyword_fav(status)
    return unless status.text
    data = [
      'かぼちゃ',
      'カボチャ',
    ]
    data.each do |str|
      if status.text.include? str
        favorite status
        break
      end
    end
  end
end
