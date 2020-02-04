# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::Util do
  context ".verify32!" do
    let(:msg) { RbNaCl::Util.zeros(32) }
    let(:identical_msg) { RbNaCl::Util.zeros(32) }
    let(:other_msg) { RbNaCl::Util.zeros(31) + "\001" }
    let(:short_msg) { RbNaCl::Util.zeros(31) }
    let(:long_msg) { RbNaCl::Util.zeros(33) }

    it "confirms identical messages are identical" do
      expect(RbNaCl::Util.verify32!(msg, identical_msg)).to be true
    end

    it "confirms non-identical messages are non-identical" do
      expect(RbNaCl::Util.verify32!(msg, other_msg)).to be false
      expect(RbNaCl::Util.verify32!(other_msg, msg)).to be false
    end

    it "raises descriptively on a short message in position 1" do
      expect { RbNaCl::Util.verify32!(short_msg, msg) }.to raise_error(RbNaCl::LengthError)
    end
    it "raises descriptively on a short message in position 2" do
      expect { RbNaCl::Util.verify32!(msg, short_msg) }.to raise_error(RbNaCl::LengthError)
    end
    it "raises descriptively on a long message in position 1" do
      expect { RbNaCl::Util.verify32!(long_msg, msg) }.to raise_error(RbNaCl::LengthError)
    end
    it "raises descriptively on a long message in position 2" do
      expect { RbNaCl::Util.verify32!(msg, long_msg) }.to raise_error(RbNaCl::LengthError)
    end
  end

  context ".verify32" do
    let(:msg) { RbNaCl::Util.zeros(32) }
    let(:identical_msg) { RbNaCl::Util.zeros(32) }
    let(:other_msg) { RbNaCl::Util.zeros(31) + "\001" }
    let(:short_msg) { RbNaCl::Util.zeros(31) }
    let(:long_msg) { RbNaCl::Util.zeros(33) }

    it "confirms identical messages are identical" do
      expect(RbNaCl::Util.verify32(msg, identical_msg)).to be true
    end

    it "confirms non-identical messages are non-identical" do
      expect(RbNaCl::Util.verify32(msg, other_msg)).to be false
      expect(RbNaCl::Util.verify32(other_msg, msg)).to be false
      expect(RbNaCl::Util.verify32(short_msg, msg)).to be false
      expect(RbNaCl::Util.verify32(msg, short_msg)).to be false
      expect(RbNaCl::Util.verify32(long_msg, msg)).to be false
      expect(RbNaCl::Util.verify32(msg, long_msg)).to be false
    end
  end

  context ".verify16!" do
    let(:msg) { RbNaCl::Util.zeros(16) }
    let(:identical_msg) { RbNaCl::Util.zeros(16) }
    let(:other_msg) { RbNaCl::Util.zeros(15) + "\001" }
    let(:short_msg) { RbNaCl::Util.zeros(15) }
    let(:long_msg) { RbNaCl::Util.zeros(17) }

    it "confirms identical messages are identical" do
      expect(RbNaCl::Util.verify16!(msg, identical_msg)).to be true
    end

    it "confirms non-identical messages are non-identical" do
      expect(RbNaCl::Util.verify16!(msg, other_msg)).to be false
      expect(RbNaCl::Util.verify16!(other_msg, msg)).to be false
    end

    it "raises descriptively on a short message in position 1" do
      expect { RbNaCl::Util.verify16!(short_msg, msg) }.to raise_error(RbNaCl::LengthError)
    end
    it "raises descriptively on a short message in position 2" do
      expect { RbNaCl::Util.verify16!(msg, short_msg) }.to raise_error(RbNaCl::LengthError)
    end
    it "raises descriptively on a long message in position 1" do
      expect { RbNaCl::Util.verify16!(long_msg, msg) }.to raise_error(RbNaCl::LengthError)
    end
    it "raises descriptively on a long message in position 2" do
      expect { RbNaCl::Util.verify16!(msg, long_msg) }.to raise_error(RbNaCl::LengthError)
    end
  end

  context ".verify16" do
    let(:msg) { RbNaCl::Util.zeros(16) }
    let(:identical_msg) { RbNaCl::Util.zeros(16) }
    let(:other_msg) { RbNaCl::Util.zeros(15) + "\001" }
    let(:short_msg) { RbNaCl::Util.zeros(15) }
    let(:long_msg) { RbNaCl::Util.zeros(17) }

    it "confirms identical messages are identical" do
      expect(RbNaCl::Util.verify16(msg, identical_msg)).to be true
    end

    it "confirms non-identical messages are non-identical" do
      expect(RbNaCl::Util.verify16(msg, other_msg)).to be false
      expect(RbNaCl::Util.verify16(other_msg, msg)).to be false
      expect(RbNaCl::Util.verify16(short_msg, msg)).to be false
      expect(RbNaCl::Util.verify16(msg, short_msg)).to be false
      expect(RbNaCl::Util.verify16(long_msg, msg)).to be false
      expect(RbNaCl::Util.verify16(msg, long_msg)).to be false
    end
  end

  context "check_length" do
    it "accepts strings of the correct length" do
      expect { RbNaCl::Util.check_length("A" * 4, 4, "Test String") }.not_to raise_error
    end
    it "rejects strings which are too short" do
      expect { RbNaCl::Util.check_length("A" * 3, 4, "Test String") }.to raise_error(RbNaCl::LengthError, "Test String was 3 bytes (Expected 4)")
    end
    it "rejects strings which are too long" do
      expect { RbNaCl::Util.check_length("A" * 5, 4, "Test String") }.to raise_error(RbNaCl::LengthError, "Test String was 5 bytes (Expected 4)")
    end
    it "rejects nil strings" do
      expect { RbNaCl::Util.check_length(nil, 4, "Test String") }.to raise_error(RbNaCl::LengthError, "Test String was nil (Expected 4)")
    end
  end

  context "check_string" do
    let(:example_string) { "foobar".dup.force_encoding("UTF-8") }

    it "raises EncodingError when given strings with non-BINARY encoding" do
      expect do
        RbNaCl::Util.check_string(example_string, example_string.bytesize, "encoding test")
      end.to raise_error(EncodingError)
    end
  end

  context "hex encoding" do
    let(:bytes) { [0xDE, 0xAD, 0xBE, 0xEF].pack("c*") }
    let(:hex)   { "deadbeef" }

    it "encodes to hex with bin2hex" do
      expect(RbNaCl::Util.bin2hex(bytes)).to eq hex
    end

    it "decodes from hex with hex2bin" do
      expect(RbNaCl::Util.hex2bin(hex)).to eq bytes
    end
  end
end
