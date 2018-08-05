Twemoji.configure do |config|
  config.asset_root = 'https://twemoji.maxcdn.com/2'
  config.file_ext   = 'svg'
  config.class_name = 'emoji'
  config.img_attrs  = { style: 'height: 1.3em;' }
end
