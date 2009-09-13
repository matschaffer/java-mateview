package com.redcareditor.mate.document;

public interface MateTextRange {

	public MateTextLocation getStart();

	public void setStart(MateTextLocation location);

	public MateTextLocation getEnd();

	public void setEnd(MateTextLocation location);
	
	public int getLength();
	public boolean conatains(MateTextLocation location);
	public boolean overlaps(MateTextRange range);
}
