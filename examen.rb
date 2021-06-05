require "uri"
require "net/http"
require "json"
def request(address,api_key)
url = URI(address+api_key)
http = Net::HTTP.new(url.host, url.port);
request = Net::HTTP::Get.new(url)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER #conexión segura
response = http.request(request)
JSON.parse response.read_body
end

data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=","5jWMxIHAuIthOyF8LyIBe1pEIXKF3nfSAFbrqW5k")

#metodo para conseguir los nombres de la camaras

def photos_count (data)
    photos = data["photos"].map{|x| x['camera']['full_name']} #buscando las camaras en el hash
    cam = ""
    photos.each do |name|#generando
        cam += "{#{name}}"
    end
    puts cam
end

#en esta forma solo cree un solo metodo para crear la pagina con las fotos.

def buid_web_page(data)
    htmltop = "<html>\n<head>\n<link rel='stylesheet' href='style.css'>\n</head>\n<body>\n\t<header>\n\t\t<h1>IMAGENES DE LA NASA</h1>\n\t</header>\n\t<section>\n\t\t<ul> " #generando el top de pagina.
    photos = data["photos"].map{|x| x['img_src']} 
    html = ""
    photos.each do |photo|
        html += "\n\t\t\t<li><img src=\"#{photo}\"><li>" #generando codigo html junto a las url de las imagenes coseguida desde la api
    end
    htmlbotom= "\n\t\t</ul>\n\t</section>\n</body>\n</html>" #generando en botom de la pagina
    index = htmltop + html + htmlbotom #ordenando las variables para el orden de la pagina
    File.write('index.html', index)
end

buid_web_page(data)
#photos_count (data)