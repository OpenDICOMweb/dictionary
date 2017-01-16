// SpookyHash adapted to Dart by Jim Philbin from http://burtleburtle.net/bob/c/Spooky

//
// SpookyHash: a 128-bit non-cryptographic hash function
// By Bob Jenkins, public domain
//   Oct 31 2010: alpha, framework + SpookyHash::Mix appears right
//   Oct 31 2011: alpha again, Mix only good to 2^^69 but rest appears right
//   Dec 31 2011: beta, improved Mix, tested it for 2-bit deltas
//   Feb  2 2012: production, same bits as beta
//   Feb  5 2012: adjusted definitions of uint/// to be more portable
//   Mar 30 2012: 3 bytes/cycle, not 4.  Alpha was 4 but wasn't thorough enough.
//   August 5 2012: SpookyV2 (different results)
//
// Up to 3 bytes/cycle for long messages.  Reasonably fast for short messages.
// All 1 or 2 bit deltas achieve avalanche within 1% bias per output bit.
//
// This was developed for and tested on 64-bit x86-compatible processors.
// It assumes the processor is little-endian.  There is a macro
// controlling whether unaligned reads are allowed (by default they are).
// This should be an equally good hash on big-endian machines, but it will
// compute different results on them than on little-endian machines.
//
// Google's CityHash has similar specs to SpookyHash, and CityHash is faster
// on new Intel boxes.  MD4 and MD5 also have similar specs, but they are orders
// of magnitude slower.  CRCs are two or more times slower, but unlike
// SpookyHash, they have nice math for combining the CRCs of pieces to form
// the CRCs of wholes.  There are also cryptographic hashes, but those are even
// slower than MD5.
//

import 'dart:typed_data';

// Bit mask for packing bytes.
const int _kByteMask = 0x0FF;

// The size of the hash engine internal state, in long words.
const int _kNumStateVars = 12;

// A block is the basic unit of data ingestion.
const int _kBlockSizeBytes = _kNumStateVars * 8;
const int _kBlockSizeChars = _kNumStateVars * 4;
const int _kBlockSizeLongs = _kNumStateVars;

// Input arrays of size less than or equal to SMALLHASH_LIMIT_BYTES are
// computed with a different algorithm to avoid the startup cost of the
// full algorithm.
const int _kSmallHashLimitBytes = _kBlockSizeBytes * 2;
const int _kSmallHashLimitChars = _kBlockSizeChars * 2;
const int _kSmallHashLimitLongs = _kBlockSizeLongs * 2;

// From comments in the original C++ version --
// "A constant which:
//  is not zero
//  is odd
//  is a not-very-regular mix of 1's and 0's
//  does not need any other special mathematical properties"
const int _kArbitraryBits = 0xDEADBEEFDEADBEEF;

// Packs eight bytes into one long value, in little-endian order.
int _packLong(Uint8List src, int start) =>
    (src[start + 7] & _kByteMask) << 56 |
    (src[start + 6] & _kByteMask) << 48 |
    (src[start + 5] & _kByteMask) << 40 |
    (src[start + 4] & _kByteMask) << 32 |
    (src[start + 3] & _kByteMask) << 24 |
    (src[start + 2] & _kByteMask) << 16 |
    (src[start + 1] & _kByteMask) << 8 |
    (src[start] & _kByteMask);

// Packs seven or fewer bytes into one long value, in little-endian order.
int _packPartialBytes(Uint8List src, int start, int length) {
  int h = 0;
  if (length == 7) h += (src[start + 6] & _kByteMask) << 48;
  if (length == 6) h += (src[start + 5] & _kByteMask) << 40;
  if (length == 5) h += (src[start + 4] & _kByteMask) << 32;
  if (length == 4) h += (src[start + 3] & _kByteMask) << 24;
  if (length == 3) h += (src[start + 2] & _kByteMask) << 16;
  if (length == 2) h += (src[start + 1] & _kByteMask) << 8;
  if (length == 1) h += (src[start] & _kByteMask);
  return h;
}

Uint64List _hasher(Uint64List x) {
  int h0 = x[0];
  int h1 = x[0];
  int h2 = x[0];
  int h3 = x[0];
  h0 ^= (h2 << 50) | (h2 >> 14) + h3;
  h1 ^= (h3 << 52) | (h3 >> 12) + h0;
  h2 ^= (h0 << 30) | (h0 >> 34) + h1;
  h3 ^= (h1 << 41) | (h1 >> 23) + h2;
  h0 ^= (h2 << 54) | (h2 >> 10) + h3;
  h1 ^= (h3 << 48) | (h3 >> 16) + h0;
  h2 ^= (h0 << 38) | (h0 >> 26) + h1;
  h3 ^= (h1 << 37) | (h1 >> 27) + h2;
  h0 ^= (h2 << 62) | (h2 >> 2) + h3;
  h1 ^= (h3 << 34) | (h3 >> 30) + h0;
  h2 ^= (h0 << 5) | (h0 >> 59) + h1;
  h3 ^= (h1 << 36) | (h1 >> 28) + h2;
  x[0] = h0;
  x[1] = h1;
  x[2] = h2;
  x[3] = h3;
  return x;
}
/// Computes the hash code for a small array of bytes (less than 192 bytes).
/// This method is called automatically when applicable.
int _smallHashBytes(Uint8List src, int start, int length, int _seed) {
  Uint64List x = new Uint64List(4);
  int h0, h1, h2, h3;
  x[0] = _seed;
  x[1] = _seed;
  x[2] = _kArbitraryBits;
  x[3] = _kArbitraryBits;

  int remaining = length;
  int pos = start;

  while (remaining >= 32) {
    x[2] += _packLong(src, pos);
    x[3] += _packLong(src, pos + 8);
    x = _hasher(x);
    x[0] += _packLong(src, pos + 16);
    x[1] += _packLong(src, pos + 24);
    pos += 32;
    remaining -= 32;
  }

  if (remaining >= 16) {
    x[2] += _packLong(src, pos);
    x[3] += _packLong(src, pos + 8);
    pos += 16;
    remaining -= 16;

    //TODO: clean up these equations as follows
    x = _hasher(x);
  }

  // assert remaining < 16;
  x[3] += (length) << 56;

  if (remaining >= 8) {
    x[2] += _packLong(src, pos);
    pos += 8;
    remaining -= 8;
    if (remaining > 0) {
      x[3] += _packPartialBytes(src, pos, remaining);
    }
  } else if (remaining > 0) {
    x[2] += _packPartialBytes(src, pos, remaining);
  } else {
    x[2] += _kArbitraryBits;
    x[3] += _kArbitraryBits;
  }

  //TODO make into subroutine as above
  h3 ^= h2;
  h2 = (h2 << 15) | (h2 >> 49);
  h3 += h2;
  h0 ^= h3;
  h3 = (h3 << 52) | (h3 >> 12);
  h0 += h3;
  h1 ^= h0;
  h0 = (h0 << 26) | (h0 >> 38);
  h1 += h0;
  h2 ^= h1;
  h1 = (h1 << 51) | (h1 >> 13);
  h2 += h1;
  h3 ^= h2;
  h2 = (h2 << 28) | (h2 >> 36);
  h3 += h2;
  h0 ^= h3;
  h3 = (h3 << 9) | (h3 >> 55);
  h0 += h3;
  h1 ^= h0;
  h0 = (h0 << 47) | (h0 >> 17);
  h1 += h0;
  h2 ^= h1;
  h1 = (h1 << 54) | (h1 >> 10);
  h2 += h1;
  h3 ^= h2;
  h2 = (h2 << 32) | (h2 >> 32);
  h3 += h2;
  h0 ^= h3;
  h3 = (h3 << 25) | (h3 >> 39);
  h0 += h3;
  h1 ^= h0;
  h0 = (h0 << 63) | (h0 >> 1);
  h1 += h0;

  return h0;
}

/// A variation of {@link SpookyHash} for use in applications that require only
/// 64-bit hash code values. When compared to {@code SpookyHash}, the following
/// differences are noted:
///
///  * The computation is identical to 128-bit SpookyHash; only the method
/// signatures and the use of the seed value are changed.
///
/// * The seed value for SpookyHash64 is a single long value, which is
/// duplicated to populate the internal 128-seed value.
///
/// *The 64-bit {@code long} hash code is always returned as the function value.
class SpookyHash64 {
  /// Default seed value used by non-static hash methods
  final int seed;

  /// Constructs a new hash engine with the specified seed value.
  //TODO:
  const SpookyHash64([this.seed = 0]);

  /// A constant SpookyHash64
  static const SpookyHash64 hash = const SpookyHash64(17);



  /// Computes the hash code for an array of bytes, using the specified seed value.
  int hashBytes(Uint8List src, [int start = 0, int length, int seed]) {
    //TODO: make _checkLength(int start, int length)
    int _length = (length == null) ? src.length : length;
    int _seed = (seed == null) ? seed : seed;
    if (_length < _kSmallHashLimitBytes) {
      return _smallHashBytes(src, start, _length, _seed);
    }

    int h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11;
    h0 = h3 = h6 = h9 = _seed;
    h1 = h4 = h7 = h10 = _seed;
    h2 = h5 = h8 = h11 = _kArbitraryBits;

    int remaining = _length;
    int pos = start;
    while (remaining >= _kBlockSizeBytes) {
      h0 += _packLong(src, pos);
      h2 ^= h10;
      h11 ^= h0;
      h0 = (h0 << 11) | (h0 >> 53);
      h11 += h1;

      h1 += _packLong(src, pos + 8);
      h3 ^= h11;
      h0 ^= h1;
      h1 = (h1 << 32) | (h1 >> 32);
      h0 += h2;

      h2 += _packLong(src, pos + 16);
      h4 ^= h0;
      h1 ^= h2;
      h2 = (h2 << 43) | (h2 >> 21);
      h1 += h3;

      h3 += _packLong(src, pos + 24);
      h5 ^= h1;
      h2 ^= h3;
      h3 = (h3 << 31) | (h3 >> 33);
      h2 += h4;

      h4 += _packLong(src, pos + 32);
      h6 ^= h2;
      h3 ^= h4;
      h4 = (h4 << 17) | (h4 >> 47);
      h3 += h5;

      h5 += _packLong(src, pos + 40);
      h7 ^= h3;
      h4 ^= h5;
      h5 = (h5 << 28) | (h5 >> 36);
      h4 += h6;

      h6 += _packLong(src, pos + 48);
      h8 ^= h4;
      h5 ^= h6;
      h6 = (h6 << 39) | (h6 >> 25);
      h5 += h7;

      h7 += _packLong(src, pos + 56);
      h9 ^= h5;
      h6 ^= h7;
      h7 = (h7 << 57) | (h7 >> 7);
      h6 += h8;

      h8 += _packLong(src, pos + 64);
      h10 ^= h6;
      h7 ^= h8;
      h8 = (h8 << 55) | (h8 >> 9);
      h7 += h9;

      h9 += _packLong(src, pos + 72);
      h11 ^= h7;
      h8 ^= h9;
      h9 = (h9 << 54) | (h9 >> 10);
      h8 += h10;

      h10 += _packLong(src, pos + 80);
      h0 ^= h8;
      h9 ^= h10;
      h10 = (h10 << 22) | (h10 >> 42);
      h9 += h11;

      h11 += _packLong(src, pos + 88);
      h1 ^= h9;
      h10 ^= h11;
      h11 = (h11 << 46) | (h11 >> 18);
      h10 += h0;

      remaining -= _kBlockSizeBytes;
      pos += _kBlockSizeBytes;
    }

    // assert remaining < _kBlockSizeBytes;
    int partialSize = remaining & 7;
    int wholeWords = remaining >> 3;
    if (partialSize > 0) {
      int partial = _packPartialBytes(src, pos + (wholeWords << 3), partialSize);
      switch (wholeWords) {
        case 0:
          h0 += partial;
          break;
        case 1:
          h1 += partial;
          break;
        case 2:
          h2 += partial;
          break;
        case 3:
          h3 += partial;
          break;
        case 4:
          h4 += partial;
          break;
        case 5:
          h5 += partial;
          break;
        case 6:
          h6 += partial;
          break;
        case 7:
          h7 += partial;
          break;
        case 8:
          h8 += partial;
          break;
        case 9:
          h9 += partial;
          break;
        case 10:
          h10 += partial;
          break;
        case 11:
          h11 += partial;
          break;
      }
    }

    if (wholeWords == 11) h10 += _packLong(src, pos + 80);
    if (wholeWords == 10) h9 += _packLong(src, pos + 72);
    if (wholeWords == 9) h8 += _packLong(src, pos + 64);
    if (wholeWords == 8) h7 += _packLong(src, pos + 56);
    if (wholeWords == 7) h6 += _packLong(src, pos + 48);
    if (wholeWords == 6) h5 += _packLong(src, pos + 40);
    if (wholeWords == 5) h4 += _packLong(src, pos + 32);
    if (wholeWords == 4) h3 += _packLong(src, pos + 24);
    if (wholeWords == 3) h2 += _packLong(src, pos + 16);
    if (wholeWords == 2) h1 += _packLong(src, pos + 8);
    if (wholeWords == 1) h0 += _packLong(src, pos);

    h11 += remaining << 56;

    for (int i = 0; i < 3; i++) {
      h11 += h1;
      h2 ^= h11;
      h1 = (h1 << 44) | (h1 >> 20);
      h0 += h2;
      h3 ^= h0;
      h2 = (h2 << 15) | (h2 >> 49);
      h1 += h3;
      h4 ^= h1;
      h3 = (h3 << 34) | (h3 >> 30);
      h2 += h4;
      h5 ^= h2;
      h4 = (h4 << 21) | (h4 >> 43);
      h3 += h5;
      h6 ^= h3;
      h5 = (h5 << 38) | (h5 >> 26);
      h4 += h6;
      h7 ^= h4;
      h6 = (h6 << 33) | (h6 >> 31);
      h5 += h7;
      h8 ^= h5;
      h7 = (h7 << 10) | (h7 >> 54);
      h6 += h8;
      h9 ^= h6;
      h8 = (h8 << 13) | (h8 >> 51);
      h7 += h9;
      h10 ^= h7;
      h9 = (h9 << 38) | (h9 >> 26);
      h8 += h10;
      h11 ^= h8;
      h10 = (h10 << 53) | (h10 >> 11);
      h9 += h11;
      h0 ^= h9;
      h11 = (h11 << 42) | (h11 >> 22);
      h10 += h0;
      h1 ^= h10;
      h0 = (h0 << 54) | (h0 >> 10);
    }
    return h0;
  }

  /// Packs four characters from a CharSequence into one long value, in little-endian order.
  static int _packString(String src, int start) =>
      src.codeUnitAt(start + 3) << 48 |
      src.codeUnitAt(start + 2) << 32 |
      src.codeUnitAt(start + 1) << 16 |
      src.codeUnitAt(start);

  /// Packs 3 or fewer characters from a CharSequence into one long value, in little-
  /// endian order.
  static int _packPartialString(String src, int start, int remaining) {
    int h = 0;
    if (remaining == 3) return h += (src.codeUnitAt(start + 2)) << 32;
    if (remaining == 2) return h += (src.codeUnitAt(start + 1)) << 16;
    if (remaining == 1) return h += (src.codeUnitAt(start));
    throw new ArgumentError("Invalid Remaining value: $remaining");
  }

  /// Computes the hash code for a small character sequence (less than 96 characters).
  /// This method is called automatically when applicable.
  static int _smallHashString(String src, int start, int length, int seed) {
    int h0, h1, h2, h3;
    h0 = seed;
    h1 = seed;
    h2 = _kArbitraryBits;
    h3 = _kArbitraryBits;

    int remaining = length;
    int pos = start;

    while (remaining >= 16) {
      h2 += _packString(src, pos);
      h3 += _packString(src, pos + 4);

      h2 = (h2 << 50) | (h2 >> 14);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 52) | (h3 >> 12);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 30) | (h0 >> 34);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 41) | (h1 >> 23);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 54) | (h2 >> 10);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 48) | (h3 >> 16);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 38) | (h0 >> 26);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 37) | (h1 >> 27);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 62) | (h2 >> 2);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 34) | (h3 >> 30);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 5) | (h0 >> 59);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 36) | (h1 >> 28);
      h1 += h2;
      h3 ^= h1;

      h0 += _packString(src, pos + 8);
      h1 += _packString(src, pos + 12);
      pos += 16;
      remaining -= 16;
    }

    if (remaining >= 8) {
      h2 += _packString(src, pos);
      h3 += _packString(src, pos + 4);
      pos += 8;
      remaining -= 8;

      h2 = (h2 << 50) | (h2 >> 14);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 52) | (h3 >> 12);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 30) | (h0 >> 34);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 41) | (h1 >> 23);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 54) | (h2 >> 10);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 48) | (h3 >> 16);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 38) | (h0 >> 26);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 37) | (h1 >> 27);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 62) | (h2 >> 2);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 34) | (h3 >> 30);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 5) | (h0 >> 59);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 36) | (h1 >> 28);
      h1 += h2;
      h3 ^= h1;
    }

    // assert remaining < 8;
    h3 += (length << 1) << 56;

    if (remaining >= 4) {
      h2 += _packString(src, pos);
      pos += 4;
      remaining -= 4;
      if (remaining > 0) {
        h3 += _packPartialString(src, pos, remaining);
      }
    } else if (remaining > 0) {
      h2 += _packPartialString(src, pos, remaining);
    } else {
      h2 += _kArbitraryBits;
      h3 += _kArbitraryBits;
    }

    h3 ^= h2;
    h2 = (h2 << 15) | (h2 >> 49);
    h3 += h2;
    h0 ^= h3;
    h3 = (h3 << 52) | (h3 >> 12);
    h0 += h3;
    h1 ^= h0;
    h0 = (h0 << 26) | (h0 >> 38);
    h1 += h0;
    h2 ^= h1;
    h1 = (h1 << 51) | (h1 >> 13);
    h2 += h1;
    h3 ^= h2;
    h2 = (h2 << 28) | (h2 >> 36);
    h3 += h2;
    h0 ^= h3;
    h3 = (h3 << 9) | (h3 >> 55);
    h0 += h3;
    h1 ^= h0;
    h0 = (h0 << 47) | (h0 >> 17);
    h1 += h0;
    h2 ^= h1;
    h1 = (h1 << 54) | (h1 >> 10);
    h2 += h1;
    h3 ^= h2;
    h2 = (h2 << 32) | (h2 >> 32);
    h3 += h2;
    h0 ^= h3;
    h3 = (h3 << 25) | (h3 >> 39);
    h0 += h3;
    h1 ^= h0;
    h0 = (h0 << 63) | (h0 >> 1);
    h1 += h0;
    return h0;
  }

  /// Computes the hash code for a character sequence, using the specified
  /// seed value.
  int hashString(String src, [int start = 0, int length, int seed]) {
    //TODO: make _checkLength(int start, int length)
    int _length = (length == null) ? src.length : length;
    int _seed = (seed == null) ? this.seed : seed;
    if (_length < _kSmallHashLimitChars) {
      return _smallHashString(src, start, _length, _seed);
    }

    int h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11;
    h0 = h3 = h6 = h9 = _seed;
    h1 = h4 = h7 = h10 = _seed;
    h2 = h5 = h8 = h11 = _kArbitraryBits;

    int remaining = _length;
    int pos = start;
    while (remaining >= _kBlockSizeChars) {
      h0 += _packString(src, pos);
      h2 ^= h10;
      h11 ^= h0;
      h0 = (h0 << 11) | (h0 >> 53);
      h11 += h1;

      h1 += _packString(src, pos + 4);
      h3 ^= h11;
      h0 ^= h1;
      h1 = (h1 << 32) | (h1 >> 32);
      h0 += h2;

      h2 += _packString(src, pos + 8);
      h4 ^= h0;
      h1 ^= h2;
      h2 = (h2 << 43) | (h2 >> 21);
      h1 += h3;

      h3 += _packString(src, pos + 12);
      h5 ^= h1;
      h2 ^= h3;
      h3 = (h3 << 31) | (h3 >> 33);
      h2 += h4;

      h4 += _packString(src, pos + 16);
      h6 ^= h2;
      h3 ^= h4;
      h4 = (h4 << 17) | (h4 >> 47);
      h3 += h5;

      h5 += _packString(src, pos + 20);
      h7 ^= h3;
      h4 ^= h5;
      h5 = (h5 << 28) | (h5 >> 36);
      h4 += h6;

      h6 += _packString(src, pos + 24);
      h8 ^= h4;
      h5 ^= h6;
      h6 = (h6 << 39) | (h6 >> 25);
      h5 += h7;

      h7 += _packString(src, pos + 28);
      h9 ^= h5;
      h6 ^= h7;
      h7 = (h7 << 57) | (h7 >> 7);
      h6 += h8;

      h8 += _packString(src, pos + 32);
      h10 ^= h6;
      h7 ^= h8;
      h8 = (h8 << 55) | (h8 >> 9);
      h7 += h9;

      h9 += _packString(src, pos + 36);
      h11 ^= h7;
      h8 ^= h9;
      h9 = (h9 << 54) | (h9 >> 10);
      h8 += h10;

      h10 += _packString(src, pos + 40);
      h0 ^= h8;
      h9 ^= h10;
      h10 = (h10 << 22) | (h10 >> 42);
      h9 += h11;

      h11 += _packString(src, pos + 44);
      h1 ^= h9;
      h10 ^= h11;
      h11 = (h11 << 46) | (h11 >> 18);
      h10 += h0;

      remaining -= _kBlockSizeChars;
      pos += _kBlockSizeChars;
    }

    // assert remaining < _kBlockSizeChars;
    int partialSize = remaining & 3;
    int wholeWords = remaining >> 2;
    if (partialSize > 0) {
      int partial = _packPartialString(src, pos + (wholeWords << 2), partialSize);
      switch (wholeWords) {
        case 0:
          h0 += partial;
          break;
        case 1:
          h1 += partial;
          break;
        case 2:
          h2 += partial;
          break;
        case 3:
          h3 += partial;
          break;
        case 4:
          h4 += partial;
          break;
        case 5:
          h5 += partial;
          break;
        case 6:
          h6 += partial;
          break;
        case 7:
          h7 += partial;
          break;
        case 8:
          h8 += partial;
          break;
        case 9:
          h9 += partial;
          break;
        case 10:
          h10 += partial;
          break;
        case 11:
          h11 += partial;
          break;
      }
    }

    if (wholeWords == 11) h10 += _packString(src, pos + 40);
    if (wholeWords == 10) h9 += _packString(src, pos + 36);
    if (wholeWords == 9) h8 += _packString(src, pos + 32);
    if (wholeWords == 8) h7 += _packString(src, pos + 28);
    if (wholeWords == 7) h6 += _packString(src, pos + 24);
    if (wholeWords == 6) h5 += _packString(src, pos + 20);
    if (wholeWords == 5) h4 += _packString(src, pos + 16);
    if (wholeWords == 4) h3 += _packString(src, pos + 12);
    if (wholeWords == 3) h2 += _packString(src, pos + 8);
    if (wholeWords == 2) h1 += _packString(src, pos + 4);
    if (wholeWords == 1) h0 += _packString(src, pos);

    h11 += (remaining << 1) << 56;

    for (int i = 0; i < 3; i++) {
      h11 += h1;
      h2 ^= h11;
      h1 = (h1 << 44) | (h1 >> 20);
      h0 += h2;
      h3 ^= h0;
      h2 = (h2 << 15) | (h2 >> 49);
      h1 += h3;
      h4 ^= h1;
      h3 = (h3 << 34) | (h3 >> 30);
      h2 += h4;
      h5 ^= h2;
      h4 = (h4 << 21) | (h4 >> 43);
      h3 += h5;
      h6 ^= h3;
      h5 = (h5 << 38) | (h5 >> 26);
      h4 += h6;
      h7 ^= h4;
      h6 = (h6 << 33) | (h6 >> 31);
      h5 += h7;
      h8 ^= h5;
      h7 = (h7 << 10) | (h7 >> 54);
      h6 += h8;
      h9 ^= h6;
      h8 = (h8 << 13) | (h8 >> 51);
      h7 += h9;
      h10 ^= h7;
      h9 = (h9 << 38) | (h9 >> 26);
      h8 += h10;
      h11 ^= h8;
      h10 = (h10 << 53) | (h10 >> 11);
      h9 += h11;
      h0 ^= h9;
      h11 = (h11 << 42) | (h11 >> 22);
      h10 += h0;
      h1 ^= h10;
      h0 = (h0 << 54) | (h0 >> 10);
    }
    return h0;
  }

  /// Computes the hash code for a small array of long (less than 12 long
  /// values). This method is called automatically when applicable.
  /// Parameter constraints are enforced by the calling method.
  static int _smallHashLong(Uint64List src, int start, int length, int seed) {
    int h0, h1, h2, h3;
    h0 = seed;
    h1 = seed;
    h2 = _kArbitraryBits;
    h3 = _kArbitraryBits;

    int remaining = length;
    int pos = start;

    while (remaining >= 4) {
      h2 += src[pos];
      h3 += src[pos + 1];

      h2 = (h2 << 50) | (h2 >> 14);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 52) | (h3 >> 12);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 30) | (h0 >> 34);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 41) | (h1 >> 23);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 54) | (h2 >> 10);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 48) | (h3 >> 16);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 38) | (h0 >> 26);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 37) | (h1 >> 27);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 62) | (h2 >> 2);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 34) | (h3 >> 30);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 5) | (h0 >> 59);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 36) | (h1 >> 28);
      h1 += h2;
      h3 ^= h1;

      h0 += src[pos + 2];
      h1 += src[pos + 3];
      pos += 4;
      remaining -= 4;
    }

    if (remaining >= 2) {
      h2 += src[pos];
      h3 += src[pos + 1];
      pos += 2;
      remaining -= 2;

      h2 = (h2 << 50) | (h2 >> 14);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 52) | (h3 >> 12);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 30) | (h0 >> 34);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 41) | (h1 >> 23);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 54) | (h2 >> 10);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 48) | (h3 >> 16);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 38) | (h0 >> 26);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 37) | (h1 >> 27);
      h1 += h2;
      h3 ^= h1;
      h2 = (h2 << 62) | (h2 >> 2);
      h2 += h3;
      h0 ^= h2;
      h3 = (h3 << 34) | (h3 >> 30);
      h3 += h0;
      h1 ^= h3;
      h0 = (h0 << 5) | (h0 >> 59);
      h0 += h1;
      h2 ^= h0;
      h1 = (h1 << 36) | (h1 >> 28);
      h1 += h2;
      h3 ^= h1;
    }

    // assert remaining < 2;
    h3 += (length << 3) << 56;

    if (remaining > 0) {
      h2 += src[pos];
    } else {
      h2 += _kArbitraryBits;
      h3 += _kArbitraryBits;
    }

    h3 ^= h2;
    h2 = (h2 << 15) | (h2 >> 49);
    h3 += h2;
    h0 ^= h3;
    h3 = (h3 << 52) | (h3 >> 12);
    h0 += h3;
    h1 ^= h0;
    h0 = (h0 << 26) | (h0 >> 38);
    h1 += h0;
    h2 ^= h1;
    h1 = (h1 << 51) | (h1 >> 13);
    h2 += h1;
    h3 ^= h2;
    h2 = (h2 << 28) | (h2 >> 36);
    h3 += h2;
    h0 ^= h3;
    h3 = (h3 << 9) | (h3 >> 55);
    h0 += h3;
    h1 ^= h0;
    h0 = (h0 << 47) | (h0 >> 17);
    h1 += h0;
    h2 ^= h1;
    h1 = (h1 << 54) | (h1 >> 10);
    h2 += h1;
    h3 ^= h2;
    h2 = (h2 << 32) | (h2 >> 32);
    h3 += h2;
    h0 ^= h3;
    h3 = (h3 << 25) | (h3 >> 39);
    h0 += h3;
    h1 ^= h0;
    h0 = (h0 << 63) | (h0 >> 1);
    h1 += h0;

    return h0;
  }

  /// Computes the hash code for an array of long, using the specified seed
  /// value.
  int hashLong(Uint64List src, [int start = 0, int length, int seed]) {
    //TODO: make _checkLength(int start, int length)
    int _length = (length == null) ? src.length : length;
    int _seed = (seed == null) ? this.seed : seed;
    if (_length < _kSmallHashLimitLongs) {
      return _smallHashLong(src, start, _length, _seed);
    }
    int h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11;
    h0 = h3 = h6 = h9 = _seed;
    h1 = h4 = h7 = h10 = _seed;
    h2 = h5 = h8 = h11 = _kArbitraryBits;
    int pos = start;
    int remaining = _length;

    // mix complete blocks:
    while (remaining >= _kBlockSizeLongs) {
      h0 += src[pos];
      h2 ^= h10;
      h11 ^= h0;
      h0 = (h0 << 11) | (h0 >> 53);
      h11 += h1;

      h1 += src[pos + 1];
      h3 ^= h11;
      h0 ^= h1;
      h1 = (h1 << 32) | (h1 >> 32);
      h0 += h2;

      h2 += src[pos + 2];
      h4 ^= h0;
      h1 ^= h2;
      h2 = (h2 << 43) | (h2 >> 21);
      h1 += h3;

      h3 += src[pos + 3];
      h5 ^= h1;
      h2 ^= h3;
      h3 = (h3 << 31) | (h3 >> 33);
      h2 += h4;

      h4 += src[pos + 4];
      h6 ^= h2;
      h3 ^= h4;
      h4 = (h4 << 17) | (h4 >> 47);
      h3 += h5;

      h5 += src[pos + 5];
      h7 ^= h3;
      h4 ^= h5;
      h5 = (h5 << 28) | (h5 >> 36);
      h4 += h6;

      h6 += src[pos + 6];
      h8 ^= h4;
      h5 ^= h6;
      h6 = (h6 << 39) | (h6 >> 25);
      h5 += h7;

      h7 += src[pos + 7];
      h9 ^= h5;
      h6 ^= h7;
      h7 = (h7 << 57) | (h7 >> 7);
      h6 += h8;

      h8 += src[pos + 8];
      h10 ^= h6;
      h7 ^= h8;
      h8 = (h8 << 55) | (h8 >> 9);
      h7 += h9;

      h9 += src[pos + 9];
      h11 ^= h7;
      h8 ^= h9;
      h9 = (h9 << 54) | (h9 >> 10);
      h8 += h10;

      h10 += src[pos + 10];
      h0 ^= h8;
      h9 ^= h10;
      h10 = (h10 << 22) | (h10 >> 42);
      h9 += h11;

      h11 += src[pos + 11];
      h1 ^= h9;
      h10 ^= h11;
      h11 = (h11 << 46) | (h11 >> 18);
      h10 += h0;

      pos += _kBlockSizeLongs;
      remaining -= _kBlockSizeLongs;
    }

    // remainingBytes < BLOCK_SIZE;
    // end:

    if (remaining == 11) h10 += src[pos + 10];
    if (remaining == 10) h9 += src[pos + 9];
    if (remaining == 9) h8 += src[pos + 8];
    if (remaining == 8) h7 += src[pos + 7];
    if (remaining == 7) h6 += src[pos + 6];
    if (remaining == 6) h5 += src[pos + 5];
    if (remaining == 5) h4 += src[pos + 4];
    if (remaining == 4) h3 += src[pos + 3];
    if (remaining == 3) h2 += src[pos + 2];
    if (remaining == 2) h1 += src[pos + 1];
    if (remaining == 1) h0 += src[pos];

    h11 += (remaining << 3) << 56;

    for (int i = 0; i < 3; i++) {
      h11 += h1;
      h2 ^= h11;
      h1 = (h1 << 44) | (h1 >> 20);
      h0 += h2;
      h3 ^= h0;
      h2 = (h2 << 15) | (h2 >> 49);
      h1 += h3;
      h4 ^= h1;
      h3 = (h3 << 34) | (h3 >> 30);
      h2 += h4;
      h5 ^= h2;
      h4 = (h4 << 21) | (h4 >> 43);
      h3 += h5;
      h6 ^= h3;
      h5 = (h5 << 38) | (h5 >> 26);
      h4 += h6;
      h7 ^= h4;
      h6 = (h6 << 33) | (h6 >> 31);
      h5 += h7;
      h8 ^= h5;
      h7 = (h7 << 10) | (h7 >> 54);
      h6 += h8;
      h9 ^= h6;
      h8 = (h8 << 13) | (h8 >> 51);
      h7 += h9;
      h10 ^= h7;
      h9 = (h9 << 38) | (h9 >> 26);
      h8 += h10;
      h11 ^= h8;
      h10 = (h10 << 53) | (h10 >> 11);
      h9 += h11;
      h0 ^= h9;
      h11 = (h11 << 42) | (h11 >> 22);
      h10 += h0;
      h1 ^= h10;
      h0 = (h0 << 54) | (h0 >> 10);
    }
    return h0;
  }
}
