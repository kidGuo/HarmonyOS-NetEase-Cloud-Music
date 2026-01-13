/**
 * Author: Finn Guo
 * Date: 2026/1/10
 */

@ObservedV2
export class SegmentedStyle {
  indicatorWidth: number = 20;
  indicatorHeight: number = 3;
  indicatorColor: ResourceColor = Color.Black;
  indicatorVerticalGap: number = 0;
  indicatorHorizontalInset: number = 26;
  contentPadding: Padding = { left: 12, top: 0, right: 12 };
  contentNormalColor: ResourceColor = '#8E8E93';
  contentSelectedColor: ResourceColor = Color.Black;
  spaceGap: number = 0;

  constructor(options?: Partial<SegmentedStyle>) {
    if (options) {
      this.indicatorWidth = options.indicatorWidth ?? this.indicatorWidth;
      this.indicatorHeight = options.indicatorHeight ?? this.indicatorHeight;
      this.indicatorColor = options.indicatorColor ?? this.indicatorColor;
      this.indicatorVerticalGap = options.indicatorVerticalGap ?? this.indicatorVerticalGap;
      this.indicatorHorizontalInset = options.indicatorHorizontalInset ?? this.indicatorHorizontalInset;
      this.contentPadding = options.contentPadding ?? this.contentPadding;
      this.contentNormalColor = options.contentNormalColor ?? this.contentNormalColor;
      this.contentSelectedColor = options.contentSelectedColor ?? this.contentSelectedColor;
      this.spaceGap = options.spaceGap ?? this.spaceGap;
    }
  }

  setIndicatorWidth(width: number): SegmentedStyle {
    this.indicatorWidth = width;
    return this;
  }

  setIndicatorHeight(height: number): SegmentedStyle {
    this.indicatorHeight = height;
    return this;
  }

  setIndicatorColor(color: ResourceColor): SegmentedStyle {
    this.indicatorColor = color;
    return this;
  }

  setIndicatorVerticalGap(gap: number): SegmentedStyle {
    this.indicatorVerticalGap = gap;
    return this;
  }

  setIndicatorHorizontalInset(inset: number): SegmentedStyle {
    this.indicatorHorizontalInset = inset;
    return this;
  }

  setContentPadding(padding: Padding): SegmentedStyle {
    this.contentPadding = padding;
    return this;
  }

  setContentNormalColor(color: ResourceColor): SegmentedStyle {
    this.contentNormalColor = color;
    return this;
  }

  setContentSelectedColor(color: ResourceColor): SegmentedStyle {
    this.contentSelectedColor = color;
    return this;
  }

  setSpaceGap(gap: number): SegmentedStyle {
    this.spaceGap = gap;
    return this;
  }
}