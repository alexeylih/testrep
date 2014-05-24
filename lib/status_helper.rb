 module StatusHelper 
   def json_status(code, reason)
        status code
        {
          :status => code,
          :reason => reason
        }.to_json
    end

    def not_found 
      p "not found"
    	body json_status 404, "Not found"
    end

    def bad_request 
    	body json_status 400, "Bad request"
    end

    def server_error
    	body json_status 500, "Server error"
    end
end