#!/usr/bin/env ruby

require "open-uri"
require "nokogiri"

  def translate_en_to_jp(word_en)
    # (1) 英単語の単語ItemIdを取得
    enc_word = URI.encode(word_en)
         # http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?
    dejizo_api_s =  "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?"
    dejizo_api_g = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?"
    dic = "EJdict"
    scope = "HEADWORD"
    match =  "EXACT"
    merge = "OR"
    prof =  "XHTML"
    pageSize =  "20"
    pageIndex =  "0"
    url =  dejizo_api_s            +
          "Dic="        + dic      + 
          "&Word="      + enc_word +
          "&Scope="     + scope    +
          "&Match="     + match    + 
          "&Merge="     + merge    +
          "&Prof="      + prof     +
          "&PageSize="  + pageSize +
          "&PageIndex=" + pageIndex 
    begin
      xml = open(url).read
      doc = Nokogiri::XML(xml)
      item_id = doc.search('ItemID').first.inner_text rescue nil
      return nil unless item_id

      # (2)英単語のItemIdから翻訳を取得
      url = dejizo_api_g        +
            "Dic="   + dic      +
            "&Item=" + item_id  +
            "&Loc="  + "&Prof=" + prof
      
      xml = open(url).read
      doc = Nokogiri::XML(xml)
      text = doc.search('Body').inner_text rescue nil
      text.gsub!(/(\r\n|\r|\n|\t|\s)/, '')
      return text  
    
    rescue Exception => e
      puts e        
    end
    
  end

def translate_goo_en_to_ja word_en, output = :one  
  #ja word list
  ja_list = Hash.new ""
  goo_url="http://dictionary.goo.ne.jp/srch/ej/#{word_en}/m0u/"
  #puts goo_url
  userAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; )'  
  begin
    html = open(goo_url,"User-Agent"=>userAgent).read
  rescue Exception =>e
    puts e
  end

  doc = Nokogiri::HTML(html)
  #検索結果のブロックをリスト化
  dl_list  = doc.css "dl"
  dl_list.each do |cell|
    attributes = cell.attributes
    if attributes["class"]
      if attributes["class"].value = "list-search-a-in"
        ja_list[cell.children[1].text] = cell.children[3].text
        #puts cell.children[3].text
      end
    end
  end
  ja_list
  ja_list[word_en] if output == :one
  
end


if ARGV.length >0
  text = translate_goo_en_to_ja ARGV[0]
else
  text = translate_en_to_jp "apple"
end
puts text

