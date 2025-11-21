module ApplicationHelper
  def tech_icon(technology)
    case technology&.downcase
    when /ruby|rails/
      content_tag(:div, class: "w-20 h-20 rounded-xl bg-gradient-to-br from-red-500 to-red-700 flex items-center justify-center shadow-lg") do
        <<~SVG.html_safe
          <svg class="w-12 h-12 text-white" viewBox="0 0 24 24" fill="currentColor">
            <path d="M20.944 12.979c-.489 4.509-4.306 8.068-8.905 8.068-4.6 0-8.416-3.559-8.905-8.068L3 13c0 5.523 4.477 10 10 10s10-4.477 10-10l-.056-.021z"/>
            <path d="M12 2C6.477 2 2 6.477 2 12h2c0-4.411 3.589-8 8-8s8 3.589 8 8h2c0-5.523-4.477-10-10-10z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
        SVG
      end
    when /react|javascript|js/
      content_tag(:div, class: "w-20 h-20 rounded-xl bg-gradient-to-br from-blue-400 to-cyan-500 flex items-center justify-center shadow-lg") do
        <<~SVG.html_safe
          <svg class="w-12 h-12 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="2"/>
            <ellipse cx="12" cy="12" rx="10" ry="4" transform="rotate(60 12 12)"/>
            <ellipse cx="12" cy="12" rx="10" ry="4" transform="rotate(120 12 12)"/>
            <ellipse cx="12" cy="12" rx="10" ry="4"/>
          </svg>
        SVG
      end
    when /python/
      content_tag(:div, class: "w-20 h-20 rounded-xl bg-gradient-to-br from-blue-500 to-yellow-400 flex items-center justify-center shadow-lg") do
        <<~SVG.html_safe
          <svg class="w-12 h-12 text-white" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9.585 11.692h4.328s2.432.039 2.432-2.35V5.391S16.714 3 11.936 3C7.362 3 7.647 4.983 7.647 4.983l.006 2.055h4.363v.617H5.92s-2.927-.332-2.927 4.282 2.555 4.45 2.555 4.45h1.524v-2.141s-.083-2.554 2.513-2.554zm-.056-5.74a.784.784 0 1 1 0-1.57.784.784 0 1 1 0 1.57z"/>
            <path d="M18.452 7.532h-1.524v2.141s.083 2.554-2.513 2.554h-4.328s-2.432-.04-2.432 2.35v3.951s-.369 2.391 4.409 2.391c4.574 0 4.289-1.983 4.289-1.983l-.006-2.054h-4.363v-.617h6.097s2.927.332 2.927-4.282-2.556-4.451-2.556-4.451zm-4.347 10.583a.784.784 0 1 1 0 1.57.784.784 0 1 1 0-1.57z"/>
          </svg>
        SVG
      end
    when /java/
      content_tag(:div, class: "w-20 h-20 rounded-xl bg-gradient-to-br from-orange-500 to-red-600 flex items-center justify-center shadow-lg") do
        <<~SVG.html_safe
          <svg class="w-12 h-12 text-white" viewBox="0 0 24 24" fill="currentColor">
            <path d="M8.851 18.56s-.917.534.653.714c1.902.218 2.874.187 4.969-.211 0 0 .552.346 1.321.646-4.699 2.013-10.633-.118-6.943-1.149M8.276 15.933s-1.028.761.542.924c2.032.209 3.636.227 6.413-.308 0 0 .384.389.987.602-5.679 1.661-12.007.13-7.942-1.218M13.116 11.475c1.158 1.333-.304 2.533-.304 2.533s2.939-1.518 1.589-3.418c-1.261-1.772-2.228-2.652 3.007-5.688 0-.001-8.216 2.051-4.292 6.573M19.33 20.504s.679.559-.747.991c-2.712.822-11.288 1.069-13.669.033-.856-.373.75-.89 1.254-.998.527-.114.828-.093.828-.093-.953-.671-6.156 1.317-2.643 1.887 9.58 1.553 17.462-.7 14.977-1.82M9.292 13.21s-4.362 1.036-1.544 1.412c1.189.159 3.561.123 5.77-.062 1.806-.152 3.618-.477 3.618-.477s-.637.272-1.098.587c-4.429 1.165-12.986.623-10.522-.568 2.082-1.006 3.776-.892 3.776-.892M17.116 17.584c4.503-2.34 2.421-4.589.968-4.285-.355.074-.515.138-.515.138s.132-.207.385-.297c2.875-1.011 5.086 2.981-.928 4.562 0-.001.07-.062.09-.118M14.401 0s2.494 2.494-2.365 6.33c-3.896 3.077-.888 4.832-.001 6.836-2.274-2.053-3.943-3.858-2.824-5.539 1.644-2.469 6.197-3.665 5.19-7.627M9.734 23.924c4.322.277 10.959-.153 11.116-2.198 0 0-.302.775-3.572 1.391-3.688.694-8.239.613-10.937.168 0-.001.553.457 3.393.639"/>
          </svg>
        SVG
      end
    else
      content_tag(:div, class: "w-20 h-20 rounded-xl bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center shadow-lg") do
        <<~SVG.html_safe
          <svg class="w-12 h-12 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="16 18 22 12 16 6"/>
            <polyline points="8 6 2 12 8 18"/>
            <line x1="14" y1="4" x2="10" y2="20"/>
          </svg>
        SVG
      end
    end
  end
end
