enum AlignType {
  left,
  right,
}

extension AlignTypeExtension on AlignType {
  static AlignType getAlignTypeFromString(String alignType) {
    alignType = alignType.toLowerCase();

    switch (alignType) {
      case 'left':
        return AlignType.left;
      case 'right':
        return AlignType.right;
      default:
        return AlignType.left;
    }
  }

  String getName() {
    switch (this) {
      case AlignType.left:
        return 'left';
      case AlignType.right:
        return 'right';
      default:
        return 'left';
    }
  }
}
