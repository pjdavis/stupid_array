# frozen_string_literal: true

#
# Adapted from: https://github.com/justinwsmith/ruby-xxhash
#
# Copyright (c) 2014 Justin W Smith
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class StupidArray
  module Support
    class XXhash32
      MEM_TOTAL_SIZE = 16
      PRIME32_1 = 2_654_435_761
      PRIME32_2 = 2_246_822_519
      PRIME32_3 = 3_266_489_917
      PRIME32_4 = 668_265_263
      PRIME32_5 = 374_761_393

      THIRTYTWO_ONES = ((2**32) - 1)

      def initialize(seed)
        @seed = seed
        reset
      end

      def reset
        @v1 = @seed + PRIME32_1 + PRIME32_2
        @v2 = @seed + PRIME32_2
        @v3 = @seed + 0
        @v4 = @seed - PRIME32_1
        @total_len = 0
        @memory = Array.new(MEM_TOTAL_SIZE)
        @memsize = 0
      end

      def update(bytes)
        bytes = bytes.unpack("C*") if bytes.is_a?(String)

        @total_len += bytes.length

        p = 0

        while (remaining = (bytes.length - p)).positive?

          mem_avail = MEM_TOTAL_SIZE - @memsize

          if remaining < mem_avail
            @memory[@memsize, remaining] = bytes[p, remaining]
            @memsize += remaining
            break
          end

          @memory[@memsize, mem_avail] = bytes[p, mem_avail]

          i = 0
          %i[v1 v2 v3 v4].each do |m|
            p32 = uint32(
              @memory[i] |
                (@memory[i + 1] << 8) |
                (@memory[i + 2] << 16) |
                (@memory[i + 3] << 24)
            )

            v = uint32(send(m) + (p32 * PRIME32_2))
            v = uint32(uint32((v << 13) | (v >> (32 - 13))) * PRIME32_1)
            send("#{m}=".to_sym, v)
            i += 4
          end

          p += mem_avail
          @memsize = 0
        end

        true
      end

      def digest(val = nil)
        update val if val

        h32 = if @total_len >= 16
                ((@v1 << 1) | (@v1 >> (32 - 1))) +
                  ((@v2 << 7) | (@v2 >> (32 - 7))) +
                  ((@v3 << 12) | (@v3 >> (32 - 12))) +
                  ((@v4 << 18) | (@v4 >> (32 - 18)))
              else
                @seed + PRIME32_5
              end

        h32 = uint32(h32 + @total_len)

        p = 0
        while p <= (@memsize - 4)
          p32 = uint32(@memory[p] |
                         (@memory[p + 1] << 8) |
                         (@memory[p + 2] << 16) |
                         (@memory[p + 3] << 24))
          h32 = uint32(h32 + (p32 * PRIME32_3))
          h32 = uint32(uint32((h32 << 17) | (h32 >> (32 - 17))) * PRIME32_4)
          p += 4
        end

        while p < @memsize
          h32 = uint32(h32 + (@memory[p] * PRIME32_5))
          h32 = uint32(uint32((h32 << 11) | (h32 >> (32 - 11))) * PRIME32_1)
          p += 1
        end

        h32 ^= h32 >> 15
        h32 = uint32(h32 * PRIME32_2)
        h32 ^= h32 >> 13
        h32 = uint32(h32 * PRIME32_3)
        h32 ^= h32 >> 16

        h32
      end

      private

      attr_accessor :v1, :v2, :v3, :v4

      def uint32(x)
        x & THIRTYTWO_ONES
      end
    end
  end
end
