# frozen_string_literal: true

module RacesHelper
  def small_banners(banners)
    banner_keys = banners.keys - [1]
    # banner_keys = banner_keys - [0]

    banner_keys.map do |k|
      # next unless banners[k]
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

  def mobile_banners(banners, banner_key)
    banner_keys = banners.keys - [1]
    content_tag :div, class: "mdl-cell mdl-cell--#{12 / banner_keys.size}-col mdl-cell--12-col-phone" do
      # debugger
      concat(
        link_to(banners[banner_key].first[1], target: '_blank') do
          concat(content_tag(:div, nil, style: "background-image: url(#{banners[banner_key].first[0]}); \
                                         height: 150px; background-position: center;",
                                        data: { images: banners[banner_key].sort_by(&:last).to_json,
                                                'current-image': banners[banner_key].first[0] }))
        end
      )
    end
  end
end
