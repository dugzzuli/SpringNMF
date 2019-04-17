package com.dugking.DTO;

public class GetMethodParamGNMF extends GetMethodParam {
	public int getAlpha() {
		return alpha;
	}
	public void setAlpha(int alpha) {
		this.alpha = alpha;
	}
	private int samples_num;
	private int attributeLength;
	//图正则约束大小
	private int alpha=10;
	public int getSamples_num() {
		return samples_num;
	}
	public void setSamples_num(int samples_num) {
		this.samples_num = samples_num;
	}
	public int getAttributeLength() {
		return attributeLength;
	}
	public void setAttributeLength(int attributeLength) {
		this.attributeLength = attributeLength;
	}
}
