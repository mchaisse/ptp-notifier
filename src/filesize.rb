# frozen_string_literal: true

class Filesize
  class << self
    def readable(size)
      units = %w(B KiB MiB GiB TiB Pib EiB)

      return '0.0 B' if size == 0
      exp = (Math.log(size) / Math.log(1024)).to_i
      exp = 6 if exp > 6

      '%.2f %s' % [size.to_f / 1024 ** exp, units[exp]]
    end
  end
end
