# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require './lib/googleapi.rb'

$site_title = 'MotiPizza'
$keywords = ['LLVM', 'Clang', 'コミックマーケット', 'きつねさん', 'LLVM本']
$description = 'MotiPizzaはメンバーが個人的に盛り上げていきたい技術情報を年に2回行われるコミックマーケットで紹介するサークルです。現在取り扱っている情報は主に LLVM に関する情報です'
$domain = "motipizza.com"

$twitter_url = 'https://twitter.com'
$twitter_api = 'http://api.twitter.com'
$twitter_icon = "http://www.paper-glasses.com/api/twipi"

$menus = [
  {:symbol => 'home', :display => 'ホーム', :url => '/'},
  {:symbol => 'activity', :display => '活動', :url => '/activity'},
  {:symbol => 'catalog', :display => 'カタログ', :url => '/catalog'},
  {:symbol => 'member', :display => 'メンバー', :url => '/member'},
]

$catalogs = {
  :c87 => {
    :img => '/img/c87.jpg',
    :clip => '/img/c87_clip.jpg',
    :title => 'ばいなり、こんこん、こんぱいる。',
    :description => 'コミックマーケット87で「ばいなり、こんこん、こんぱいる。」を頒布します by MotiPizza',
    :url => '/catalog/c87',
    :date => '2014/12/30',
    :location => 'コミックマーケット 87',
  },

  :c85 => {
    :img => '/img/c85.jpg',
    :clip => '/img/c85_clip.jpg',
    :title => 'きつねさんとおぼえる！Clang おかわり',
    :description => 'コミックマーケット85で「きつねさんとおぼえる！Clang おかわり」を頒布します by MotiPizza',
    :url => '/catalog/c85',
    :date => '2013/12/31',
    :location => 'コミックマーケット 85',
  },

  :c84 => {
    :img => '/img/c84.jpg',
    :clip => '/img/c84_clip.jpg',
    :title => 'きつねさんとおぼえる！Clang',
    :description => 'コミックマーケット84で「きつねさんとおぼえる！Clang」を頒布します by MotiPizza',
    :url => '/catalog/c84',
    :date => '2013/08/12',
    :location => 'コミックマーケット 84',
  },

  :'impress-kitsune' => {
    :img => '/img/impress-kitsune.jpg',
    :clip => '/img/impress-kitsune_clip.jpg',
    :title => 'きつねさんでもわかるLLVM',
    :subtitle => '~コンパイラを自作するためのガイドブック~',
    :description => 'インプレスジャパン様より「きつねさんでもわかるLLVM ~コンパイラを自作するためのガイドブック~」を発売中。',
    :url => '/catalog/impress-kitsune',
    :date => '2013/06/21',
    :location => 'インプレスジャパン',
  },

  :'eb-kitsune' => {
    :img => '/img/eb-kitsune.jpg',
    :clip => '/img/eb-kitsune_clip.jpg',
    :title => 'きつねさんでもわかるLLVM',
    :description => '達人出版会様より「きつねさんでもわかるLLVM」を販売中。',
    :url => '/catalog/eb-kitsune',
    :date => '2013/02/08',
    :location => '達人出版会',
  },

  :c83 => {
    :img => '/img/c83.jpg',
    :clip => '/img/c83_clip.jpg',
    :title => 'きつねさんとおぼえるLLVM',
    :description => 'コミックマーケット83で「きつねさんとおぼえるLLVM」を頒布します by MotiPizza',
    :url => '/catalog/c83',
    :date => '2012/12/31',
    :location => 'コミックマーケット 83',
  },

  :c82 => {
    :img => '/img/c82.jpg',
    :clip => '/img/c82_clip.jpg',
    :title => '3日で出来るLLVM',
    :description => 'コミックマーケット82で「3日で出来るLLVM」を頒布します by MotiPizza',
    :url => '/catalog/c82',
    :date => '2012/08/11',
    :location => 'コミックマーケット 82',
  },
}

$updates = [
  {:date => '2014/12/30', :detail => 'C87で「ばいなり、こんこん、こんぱいる。」を出します。'},
  {:date => '2013/12/30', :detail => 'C85で「きつねさんとおぼえる！Clang おかわり」を出します。'},
  {:date => '2013/08/04', :detail => 'C84で「きつねさんとおぼえる！Clang」を出します。'},
  {:date => '2013/07/10', :detail => 'C84のページだけつくりました'},
  {:date => '2013/07/02', :detail => '電子書籍版「きつねさんでもわかるLLVM」のv0.9.2を公開しました。'},
  {:date => '2013/06/02', :detail => 'インプレスジャパン様より「きつねさんでもわかるLLVM~コンパイラを自作するためのガイドブック~」が発売されます。'},
  {:date => '2013/02/24', :detail => '「きつねさんでもわかるLLVM」の訂正一覧ページを追加しました。'},
  {:date => '2013/02/08', :detail => '達人出版会様より「きつねさんでもわかるLLVM」を販売開始しました。'},
  {:date => '2013/02/03', :detail => 'ほーむぺーじ完成'},
]

$members = {
  :sui_moti => {
    :name => '柏木餅子',
    :twitter => "#{$twitter_url}/sui_moti",
    :twitter_icon => "#{$twitter_icon}/sui_moti/original",
    :introduction => '所謂いいだしっぺ。LLVM本のフロントエンドやミドルエンドを担当。',
    :links => {
      :github => 'https://github.com/Kmotiko',
      :blog => 'http://d.hatena.ne.jp/motipizza/',
    }
  },
  :kazegusuri => {
    :name => '風薬',
    :twitter => "#{$twitter_url}/kazegusuri",
    :twitter_icon => "#{$twitter_icon}/kazegusuri/original",
    :introduction => 'まきぞえ。LLVM本のバックエンドを担当。',
    :links => {
      :github => 'https://github.com/sabottenda',
      :blog => 'http://d.hatena.ne.jp/sabottenda/',
    }
  },
  :yagamphase => {
    :name => '矢上栄一',
    :twitter => "#{$twitter_url}/yagamphase",
    :twitter_icon => "#{$twitter_icon}/yagamphase/original",
    :introduction => 'まきぞえ。イラスト担当',
    :links => {
      :tumblr => 'http://amphase.tumblr.com/',
      :website => 'http://yew.digiweb.jp/',
    }
  },
}

before do
  @url = "http://#{$domain}#{request.fullpath}"
end

get '/' do
  @active_menu = 'home'
  @list = $catalogs.values.slice(0,5)
  @description = $description
  @og_image = "http://#{$domain}" + $catalogs.values.first[:clip]
  haml :index
end

get '/activity' do
  @page_title = '活動'
  @active_menu = 'activity'
  @description = $description
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
  @description = $description
  haml :member
end

get '/catalog/c87' do
  @catalog = $catalogs[:c87]
  @page_title = @catalog[:title]
  @description = @catalog[:description]
  @og_image = "http://#{$domain}" + @catalog[:clip]
  haml :c87
end

get '/catalog/c85' do
  @catalog = $catalogs[:c85]
  @page_title = @catalog[:title]
  @description = @catalog[:description]
  @og_image = "http://#{$domain}" + @catalog[:clip]
  haml :c85
end

get '/catalog/c84' do
  @catalog = $catalogs[:c84]
  @page_title = @catalog[:title]
  @description = @catalog[:description]
  @og_image = "http://#{$domain}" + @catalog[:clip]
  haml :c84
end

get '/catalog/impress-kitsune' do
  @catalog = $catalogs[:'impress-kitsune']
  @page_title = @catalog[:title] + @catalog[:subtitle]
  @description = @catalog[:description]
  @og_image = "http://#{$domain}" + @catalog[:clip]
  haml :'impress-kitsune'
end

get '/catalog/eb-kitsune' do
  @catalog = $catalogs[:'eb-kitsune']
  @page_title = @catalog[:title]
  @description = @catalog[:description]
  @og_image = "http://#{$domain}" + @catalog[:clip]
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
  @description = @catalog[:description]
  @og_image = "http://#{$domain}" + @catalog[:clip]
  haml :c83
end

get '/catalog/c82' do
  @catalog = $catalogs[:c82]
  @page_title = @catalog[:title]
  @description = @catalog[:description]
  @og_image = "http://#{$domain}" + @catalog[:clip]
  haml :c82
end

