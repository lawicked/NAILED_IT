module MessagesHelper
  def markdown(text)
    return '' if text.blank?

    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true),
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      space_after_headers: true,
      space_before_headers: true
    )

    markdown.render(text).html_safe
  end
end
