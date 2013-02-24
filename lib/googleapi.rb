# -*- coding: utf-8 -*-
require 'google/api_client'
require 'csv'

def get_google_api_client()
  key = OpenSSL::PKey::RSA.new(ENV['GOOGLE_API_KEY'])
  asserter = Google::APIClient::JWTAsserter.new(ENV['GOOGLE_API_EMAIL'],
                                                'https://www.googleapis.com/auth/drive', key)
  client = Google::APIClient.new(:application_name => 'MotiPizza');
  client.authorization = asserter.authorize()
  client
end

def print_file(client, file_id)
  @drive = client.discovered_api('drive', 'v2')
  result = client.execute(
    :api_method => @drive.files.get,
                          :parameters => { :fileId => file_id })
  if result.status == 200
    file = result.data
    puts "Title: #{file.title}"
    puts "Description: #{file.description}"
    puts "MIME type: #{file.mime_type}"
    puts file.to_hash
    return file
  else
    puts "An error occurred: #{result.data['error']['message']}"
  end
end

def download_file(client, file)
  puts file.download_url
  if file.download_url
    result = client.execute(:uri => file.download_url)
    if result.status == 200
      return result.body
    else
      puts "An error occurred: #{result.data['error']['message']}"
      return nil
    end
  else
    # The file doesn't have any content stored on Drive.
    return nil
  end
end

def get_spreadsheet(client, key)
  result = client.execute(:uri => "https://docs.google.com/feeds/download/spreadsheets/Export?exportFormat=csv&key=#{key}")
  if result.status == 200
    return result.body
  else
    puts "An error occurred: #{result.data['error']['message']}"
    return nil
  end
end

if $0 == __FILE__ then
  # key = '0AvA30B4fFQDTdDNfUXdXamtXWWl5WUpNOWhUVThlRUE'
  key = '0AvA30B4fFQDTdGNJSjdnQzFfSGNHRDlSazlCRGxFVmc'
  cli = get_google_api_client
  data = get_spreadsheet(cli, key)
  table = CSV.parse(data)
  table.map! do |csv|
    csv.map!{|x| x.force_encoding("UTF-8") unless x.nil?}
  end

  table.each do |t|
    p t
  end
end

