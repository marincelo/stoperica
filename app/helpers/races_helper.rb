# frozen_string_literal: true

module RacesHelper
  def small_banners(banners)
    banner_keys = banners.keys - [0, 1]

    banner_keys.map do |k|
      banner = banners[k]
      content_tag :div, class: "mdl-cell mdl-cell--#{12 / banner_keys.size}-col mdl-cell--12-col-phone" do
        concat(
          link_to(banner.first[1], target: '_blank') do
            concat(content_tag(:div, nil, style: "background-image: url(#{banner.first[0]}); \
                   height: 150px; background-position: center;",
                                          data: { images: banner.sort_by(&:last).to_json,
                                                  'current-image': banner.first[0] }))
          end
        )
      end
    end.join.html_safe
  end
end
