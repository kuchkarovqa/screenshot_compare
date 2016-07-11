#coding: utf-8
require 'watircats'
require 'fastimage'
require 'base64'

module ScreenshotComparer

  def compare_screenshots(current_screenshots, sample_screenshots, out_folder = "compared")
    result = comparer(current_screenshots, sample_screenshots, out_folder).results.first
    raise("Comparison of screenshots has been interrupted with a message: '#{result[:result]}'") unless is_number?(result[:result])
    compared_shot_path =  "#{out_folder}/#{result[:compared_shot]}"
    @compared_shot = encode_image(compared_shot_path) # for ebmed picture in after hook
    get_diff_percent(current_screenshots, result[:result])
  end

  private

  def comparer(current_screenshots, sample_screenshots, out_folder)
    FileUtils.mkdir_p(out_folder) unless File.directory?(out_folder)
    WatirCats.configure :output_dir => out_folder
    comp = WatirCats::Comparer.new(File.dirname(current_screenshots), File.dirname(sample_screenshots))
    comp.compare_images(current_screenshots, sample_screenshots, out_folder)
    comp
  end

  def encode_image(img)
    Base64.encode64(open(img) { |io| io.read })
  end

  def get_diff_percent(current_screenshot, diff_px)
    img_size = FastImage.size(current_screenshot)
    percent = (diff_px.to_f/(img_size[0].to_f * img_size[1].to_f))*100
    percent.round(3)
  end

  def is_number?(string)
    true if Float(string) rescue false
  end

end