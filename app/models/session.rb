# encoding: utf-8

class Session < ActiveRecord::Base
  def self.sweep()
    delete_all("created_at < '#{SESSION_WIPEOUT_HOURS.ago.to_s(:db)}' ")
  end
end