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
#en esta forma cree metodos para el top de la pagina y boton de la pagina.

#metodo para conseguir los nombres de la camaras

def photos_count (data)
    photos = data["photos"].map{|x| x['camera']['full_name']} #buscando las camaras en el hash
    cam = ""
    photos.each do |name|#generando
        cam += "{#{name}}"
    end
    puts cam
    puts photos.count
end


#generando el top de la pagina
def topage()
"<html>
<head>
<link rel='stylesheet' href='style.css'>
</head>
<body>
    <header>
        <h1>IMAGENES DE LA NASA</h1>
    </header>
    <section>
        <ul>"
end
#generando el boton de la pagina
def botompage()
"\n        </ul>
    </section>
</body>
</html>"
end

data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=","5jWMxIHAuIthOyF8LyIBe1pEIXKF3nfSAFbrqW5k")
#metodo para generar pagina
def buid_web_page(data)
    photos = data["photos"].map{|x| x['img_src']} #buscando las url de las fotos en el hash
    html = ""
    photos.each do |photo|
        html += "\n\t\t\t<li><img src=\"#{photo}\"><li>" #generando los codigo html para la pagina
    end
index = topage()+ html+ botompage() #generando el orden del codigo para crear el index
File.write('indexforma2.html', index)#generando los el archivo html
# puts index
end


buid_web_page(data)
#photos_count (data)

