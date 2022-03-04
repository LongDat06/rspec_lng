Mongoid::Search.setup do |config|

  # Strip symbols regex to be replaced. These symbols will be replaced by space
  config.strip_symbols = /[:;'\"`,?|+={}!@^&*<>~\$\-\\\[\]]/

  # Strip accents regex to be replaced. These sybols will be removed after strip_symbols replacing
  config.strip_accents = /[^\s\p{Alnum}#\/()%._]/

end
