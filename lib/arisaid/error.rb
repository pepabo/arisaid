module Arisaid
  class Error < StandardError; end
  class ConfNotFound < Error; end
  class InvalidConf < Error; end
end
