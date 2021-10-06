require 'rails_helper'

RSpec.describe "Transcodings", type: :request do
  describe "POST /transcoding" do
    it 'return unprocessable_entity because video has not been sent' do
      post '/transcoding', params: { transcode_id: SecureRandom.uuid }

      expect(JSON.parse(response.body)).to eq({"error"=>["File должен присутствовать"]})
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return unprocessable_entity because video file duration over 1 minute' do
      post '/transcoding', params: { transcode_id: SecureRandom.uuid, media: fixture_file_upload('over_1_minute.mp4', 'video/mp4') }

      expect(JSON.parse(response.body)).to eq({"error"=>["Продолжительность видео должно быть меньше минуты."]})

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return unprocessable_entity because video file has invalid extension' do
      post '/transcoding', params: { transcode_id: SecureRandom.uuid, media: fixture_file_upload('video.txt', 'text/txt') }

      expect(JSON.parse(response.body)).to eq({"error"=>["Поддерживаемые форматы .flv .mpeg .ogm .mpg .wmv .webm .ogv .mov .m4v .asx .mp4 .avi."]})
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return unprocessable_entity because transcode_id blank' do
      post '/transcoding', params: { media: fixture_file_upload('les_1_minute.mp4', 'video/mp4') }

      expect(JSON.parse(response.body)).to eq({"error"=>["Transcode должен присутствовать"]})
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'return ok' do
      post '/transcoding', params: { transcode_id: SecureRandom.uuid, media: fixture_file_upload('les_1_minute.mp4', 'video/mp4') }

      expect(response).to have_http_status(:ok)
    end
  end
end
