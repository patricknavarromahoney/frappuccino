require 'test_helper'

describe "injecting streams" do
  it "will proxy to the stream\'s value" do
    plus_button = PlusOneButton.new
    minus_button = MinusOneButton.new

    stream_one = Frappuccino::Stream.new(plus_button)
    stream_two = Frappuccino::Stream.new(minus_button)
    merged_stream = stream_one.merge(stream_two)
    counter = merged_stream
              .inject(Hash.new(1)) {|hzh, n|
                if hzh.key?(n)
                  hzh[n]=(hzh[n]+1)
                else
                  hzh[n]=1
                end
                hzh
              }

    plus_button.push
    assert_equal 1, counter[:+]

    minus_button.push
    assert_equal 1, counter[:-]

    2.times { minus_button.push }
    assert_equal(3, counter[:-])

    4.times { plus_button.push }
    assert_equal 5, counter[:+]
  end
end
