module EmojiHelper
  def emojify(content, **options)
    Twemoji.parse(h(content), options).html_safe if content.present?
  end
end
