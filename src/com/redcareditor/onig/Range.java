package com.redcareditor.onig;

public class Range {
	public int start;
	public int end;

	public Range(int start, int end) {
		super();
		this.start = start;
		this.end = end;
	}

	@Override
	public String toString() {
		return String.format("[%d,%d]", start, end);
	}
}