package com.dugking.model;

import java.util.ArrayList;

public class XAxis {
	private ArrayList<String> categories=new ArrayList<String>();

	public ArrayList<String> getCategories() {
		return categories;
	}

	public void setCategories(ArrayList<String> categories) {
		this.categories = categories;
	}

	public XAxis(ArrayList<String> categories) {
		super();
		this.categories = categories;
	}

	public XAxis() {
		super();
	}
	
	
}
