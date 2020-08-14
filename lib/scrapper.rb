class Scrapper

  #recuperation de l'adresse mail
  def get_email(townhall_url)
    email = ""
    page = Nokogiri::HTML(URI.open(townhall_url))
    page.xpath('//td[contains(text(), "@")]').each do |el|
      email += el.text
    end
    return email
  end

  def get_urls
    arr_url = []
    arr_names = []
    arr_email = []

    #recuperation des lien de chaque mairie
    page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
    page.xpath('//a[contains(@href, "95")]/@href').each do |el|
      arr_url.push(el.value)
    end

    #recuperation de chaque non de ville
    name = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
    name.xpath('//a[contains(@href, "95")]').each do |el|
      arr_names.push(el.text)
    end

    #recuperation des e-mails
    arr_url.each do |el|
      el = el[1..-1]
      tmp_str = "https://www.annuaire-des-mairies.com" + el
      arr_email.push(get_email(tmp_str))
    end
    
    hash = arr_names.zip(arr_email).to_h
    return hash
  end
=begin
  def save_as_spreadsheet
    index = 1
    #creation d'une session
    session = GoogleDrive::Session.from_config("config.json")

    #mis en place du cle du google sheets
    ws = session.spreadsheet_by_key("0b90c7f1163d1a4116a4e1e1b14ceb87ee01f0c9").worksheets[0]

    @@my_hash.each_key do |key|
     ws[index, 1] = key
     ws[index, 2] = @@my_hash[key]
     index += 1
    end
  ws.save
  # Reloads the worksheet to get changes by other clients.
  ws.reload
  end
=end
  def registre_csv
    File.open("./db/email.csv", "w") do |f|
      f << @@my_hash.map { |c| c.join(",")}.join("\n")
    end
  end

  def registre_json
    File.open("./db/emails.JSON","w") do |f|
      f << @@my_hash.to_json
    end
  end

  def perform
    @@my_hash = Scrapper.new.get_urls
    registre_json
    registre_csv 
    #save_as_spreadsheet
 end

end