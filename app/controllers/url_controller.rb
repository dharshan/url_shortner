class UrlController < ApplicationController

  def create
    url = Url.new(url_create_params)
    shorter_url = generate_shortened_url(url.original_url)
    url.short_url = shorter_url
    if url.save
      render json: { original_url: url.original_url, short_url: url.short_url }, status: :created
    else
      render json: {error: 'error'}
    end
  end

  def find_original_url
    url = Url.find_by_short_url(params[:short_url])
    if url.present?
      render json: { status: 'success', original_url: url.original_url }, status: :ok
    else
      render json: { error: 'url not found' }, status: :not_found
    end
  end

  private

  def url_create_params
    params.require(:url).permit(:original_url)
  end

  def generate_shortened_url(url)
    url = 'http://cybrl/'
    chars = ['0'..'9','A'..'Z','a'..'z'].map{|range| range.to_a}.flatten
    uniq_shortened_key = 6.times.map{chars.sample}.join
    url << uniq_shortened_key
    url
  end
end
