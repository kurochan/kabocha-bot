# -*- encoding: utf-8 -*-
module KabochaRt
  def kabocha_rt
    result = @client.search("かぼちゃ")
    return unless result.attrs[:statuses]
    result.attrs[:statuses].each do |status|
      unless status[:text].start_with? '@'
        @client.retweet status[:id]
        break
      end
    end
  end
end
