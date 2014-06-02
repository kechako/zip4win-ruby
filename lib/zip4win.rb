# -*- coding: utf-8 -*-

require "zip4win/version"
require "zip4win/zip"

module Zip4win
  def self.run
    Zip.new.run
  end
end
