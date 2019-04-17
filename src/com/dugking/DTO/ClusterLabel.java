package com.dugking.DTO;

public class ClusterLabel {
	private int code;
	private String desc;
	public double[][] H;
	public double[][] getH() {
		return H;
	}

	public void setH(double[][] h) {
		H = h;
	}

	public int[] Label;

	public int[] getLabel() {
		return Label;
	}

	public void setLabel(int[] label) {
		Label = label;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}
}
