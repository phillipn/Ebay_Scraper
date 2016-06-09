namespace :scraper do
  desc "Scrapes Ebay"
  task scrape: :environment do
    require 'open-uri'
    require 'json'

    auth_token = "715d5fd2156a800042402c65420ab385"
    search_url = "http://search.3taps.com"
    
    10.times do |i|
      params = {
        auth_token: auth_token,
        # anchor: {ANCHOR}, searches are not static, new ones coming in all the time. Set anchor to stop the flow
        source: "EBAYM",
        'location.country' => "USA",
        retvals: "location,external_url,heading,body,timestamp,price,images,annotations",
        anchor: 2512292322,
        page: i + 1
      }

      # Prepare API request
      uri = URI.parse(search_url)
      uri.query = URI.encode_www_form(params)

      result = JSON.parse(open(uri).read)

      result["postings"].each do |posting|

        # Create new Post
        @post = Post.new
        @post.warranty = posting["annotations"]["warranty"]
        @post.origin = posting["annotations"]["country/region_of_manufacture"]
        @post.brand = posting["annotations"]["brand"]
        @post.listing_type = posting["annotations"]["listing_type"]
        @post.manufacturer_part_number = posting["annotations"]["manufacturer_part_number"]
        @post.heading = posting["heading"]
        @post.body = posting["body"]
        @post.price = posting["price"]
        @post.external_url = posting["external_url"]
        @post.location = posting["location"]["formatted_address"]
        @post.timestamp = posting["timestamp"]

        # Save Post
        @post.save
          
        posting['images'].each do |image|
          @image = Image.new
          @image.post_id = @post.id
          @image.url = image['full']
          @image.save
        end
      end
    end
  end

  desc "Destroy posts"
  task destroy_all_posts: :environment do
    Post.destroy_all
  end

end
