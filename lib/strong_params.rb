module StrongParams
  def require(key)
    self[key]
  end

  def permit(*keys)
    result = self.clone
    keys_hash = keys.map{ |key| [key.to_s, false] }.to_h

    result.keys.each do |key|
      keys_hash.has_key?(key) ? (keys_hash[key] = true) : result.delete(key)
    end

    if keys_hash.has_value? false
      unpermitted_params = keys_hash.select{ |key, value| !value }.keys
                                    .map{ |key| ":#{key}"}.join(', ')
      raise ArgumentError, "Unpermitted params[#{unpermitted_params}]"
    end

    result
  end
end
