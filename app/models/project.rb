class Project < ApplicationRecord
    
    has_many :pictures
    accepts_nested_attributes_for :pictures
    
    def generate_kml
        filename = Rails.root.join('uploads', "#{self.id}" , "doc.kml")
        content = []
        content.push('<?xml version="1.0" encoding="UTF-8"?>')
        content.push('<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">')
        content.push('<Document>')
        content.push("<name>#{self.id}.kmz</name>")
        self.pictures.each do |pic|
        pic_title = pic.image.to_s.split('/').last
        lat_parts = pic.lat.to_s.split(/[,\/]/)
        lat_parts = lat_parts.map {|x| x.to_f}
        lat_decimal = (lat_parts[0] / lat_parts[1]) + (lat_parts[2] / lat_parts[3] / 60.0) + (lat_parts[4] / lat_parts[5] / 3600.0)
        long_parts = pic.long.to_s.split(/[,\/]/)
        long_parts = long_parts.map {|x| x.to_f}
        long_decimal = (long_parts[0] / long_parts[1]) + (long_parts[2] / long_parts[3] / 60.0) + (long_parts[4] / long_parts[5] / 3600.0)
        content.push('<Placemark>')
        content.push("<name>#{pic_title}</name>")
        content.push('<description>')
        content.push('<![CDATA[')
        line = '<img style="max-width:1000px;" src="' + '' + pic_title + '">' 
        content.push(line)
        content.push(']]>')
        content.push('</description>')
        content.push('<Point>')
        content.push("<coordinates>-#{long_decimal},#{lat_decimal}</coordinates>")
        content.push('</Point>')
        content.push('</Placemark>')
        end
        content.push('</Document>')
        content.push('</kml>')
        
        s3 = Aws::S3::Resource.new
        obj = s3.bucket(ENV['S3_BUCKET']).object('test')
        File.open("kmltest", "w+") { |f| 
        f.puts(content)
        obj.put(body: f)
        }
    end
   
 
end

# style="max-width:500px;"
