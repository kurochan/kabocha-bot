# -*- encoding: utf-8 -*-
class KabochaBot < TwitterBot
  def initialize
    super
    require_plugin 'kabocha_rt'
    require_plugin 'random_tweet'
    init_task
    job :intval => 320.minutes, :func => :normal_task
    job :intval => 120.minutes, :func => :rt_task
  end

  def init_task
  end

  def normal_task
    random_tweet
  end

  def rt_task
    kabocha_rt
  end
end
