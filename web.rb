# -*- coding: utf-8 -*-
require 'sinatra'
require 'haml'
require './lib/googleapi.rb'

$site_title = 'MotiPizza'

$twitter_url = 'https://twitter.com'
$twitter_api = 'http://api.twitter.com'
$twitter_icon = "#{$twitter_api}/1/users/profile_image?size=bigger&screen_name="

$menus = [
  {:symbol => 'home', :display => 'ホーム', :url => '/'},
  {:symbol => 'activity', :display => '活動', :url => '/activity'},
  {:symbol => 'catalog', :display => 'カタログ', :url => '/catalog'},
  {:symbol => 'member', :display => 'メンバー', :url => '/member'},
]

$catalogs = {
  :c84 => {
    :img => '/img/c84.jpg',
    :clip => '/img/c84_clip.jpg',
    :title => 'きつねさんとわかるClang',
    :url => '/catalog/c84',
    :date => '2013/08/12',
    :location => 'コミックマーケット 84',
  },

  :'impress-kitsune' => {
    :img => '/img/impress-kitsune.jpg',
    :clip => '/img/impress-kitsune_clip.jpg',
    :title => 'きつねさんでもわかるLLVM',
    :subtitle => '~コンパイラを自作するためのガイドブック~',
    :url => '/catalog/impress-kitsune',
    :date => '2013/06/21',
    :location => 'インプレスジャパン',
  },

  :'eb-kitsune' => {
    :img => '/img/eb-kitsune.jpg',
    :clip => '/img/eb-kitsune_clip.jpg',
    :title => 'きつねさんでもわかるLLVM',
    :url => '/catalog/eb-kitsune',
    :date => '2013/02/08',
    :location => '達人出版会',
  },

  :c83 => {
    :img => '/img/c83.jpg',
    :clip => '/img/c83_clip.jpg',
    :title => 'きつねさんとおぼえるLLVM',
    :url => '/catalog/c83',
    :date => '2012/12/31',
    :location => 'コミックマーケット 83',
  },

  :c82 => {
    :img => '/img/c82.jpg',
    :clip => '/img/c82_clip.jpg',
    :title => '3日で出来るLLVM',
    :url => '/catalog/c82',
    :date => '2012/08/11',
    :location => 'コミックマーケット 82',
  },
}

$updates = [
  {:date => '2013/07/10', :detail => 'C84のページだけつくりました'},
  {:date => '2013/07/02', :detail => '電子書籍版「きつねさんでもわかるLLVM」のv0.9.2を公開しました。'},
  {:date => '2013/06/02', :detail => 'インプレスジャパン様より「きつねさんでもわかるLLVM~コンパイラを自作するためのガイドブック~」が発売されます。'},
  {:date => '2013/02/24', :detail => '「きつねさんでもわかるLLVM」の訂正一覧ページを追加しました。'},
  {:date => '2013/02/08', :detail => '達人出版会様より「きつねさんでもわかるLLVM」を販売開始しました。'},
  {:date => '2013/02/03', :detail => 'ほーむぺーじ完成'},
  {:date => '2013/02/02', :detail => '今日もがんばった。'},
]

$members = {
  :sui_moti => {
    :name => '柏木餅子',
    :twitter => "#{$twitter_url}/sui_moti",
    :twitter_icon => "#{$twitter_icon}sui_moti",
    :introduction => '所謂いいだしっぺ。LLVM本のフロントエンドやミドルエンドを担当。',
    :links => {
      :github => 'https://github.com/Kmotiko',
      :blog => 'http://d.hatena.ne.jp/motipizza/',
    }
  },
  :kazegusuri => {
    :name => '風薬',
    :twitter => "#{$twitter_url}/kazegusuri",
    :twitter_icon => "#{$twitter_icon}kazegusuri",
    :introduction => 'まきぞえ。LLVM本のバックエンドを担当。',
    :links => {
      :github => 'https://github.com/sabottenda',
      :blog => 'http://d.hatena.ne.jp/sabottenda/',
    }
  },
  :re_sonanz => {
    :name => '矢上栄一',
    :twitter => "#{$twitter_url}/re_sonanz",
    :twitter_icon => "#{$twitter_icon}re_sonanz",
    :introduction => 'まきぞえ。イラスト担当',
    :links => {
      :tumblr => 'http://amphase.tumblr.com/',
      :website => 'http://yew.digiweb.jp/',
    }
  },
}

get '/' do
  @active_menu = 'home'
  @list = $catalogs.values
  haml :index
end

get '/activity' do
  @page_title = '活動'
  @active_menu = 'activity'
  haml :activity
end

get '/catalog' do
  @page_title = 'カタログ'
  @active_menu = 'catalog'
  haml :catalog
end

get '/member' do
  @page_title = 'メンバー'
  @active_menu = 'member'
  haml :member
end

get '/catalog/c84' do
  @catalog = $catalogs[:c84]
  @page_title = @catalog[:title]
  haml :c84
end

get '/catalog/impress-kitsune' do
  @catalog = $catalogs[:'impress-kitsune']
  @page_title = @catalog[:title] + @catalog[:subtitle]
  haml :'impress-kitsune'
end

get '/catalog/eb-kitsune' do
  @catalog = $catalogs[:'eb-kitsune']
  @page_title = @catalog[:title]
  haml :'eb-kitsune'
end

get '/catalog/eb-kitsune/eratta' do
  @catalog = $catalogs[:'eb-kitsune']
  @page_title = @catalog[:title] + "の訂正一覧"
  key = '0AvA30B4fFQDTdGNJSjdnQzFfSGNHRDlSazlCRGxFVmc'
  client = get_google_api_client
  csv = get_spreadsheet(client, key)
  @eratta = CSV.parse(csv)
  @eratta.map! do |csv|
    csv.map!{|x| x.force_encoding("UTF-8") unless x.nil?}
  end
  @table_header = @eratta.shift
  @eratta.select!{|x| x[6] == 'v'}
  @eratta.sort!{|a,b| a[1].to_i <=> b[1].to_i}
  haml :'eb-kitsune-eratta'
end

get '/catalog/c83' do
  @catalog = $catalogs[:c83]
  @page_title = @catalog[:title]
  haml :c83
end

get '/catalog/c82' do
  @catalog = $catalogs[:c82]
  @page_title = @catalog[:title]
  haml :c82
end

