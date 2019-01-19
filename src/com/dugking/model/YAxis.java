package com.dugking.model;

import java.util.ArrayList;
import java.util.Map;

public class YAxis {
	private Map<String,String> title;
	private ArrayList<PlotLine> plotLines;
	public ArrayList<PlotLine> getPlotLines() {
		return plotLines;
	}

	public void setPlotLines(ArrayList<PlotLine> plotLines) {
		this.plotLines = plotLines;
	}

	public Map<String,String> getTitle() {
		return title;
	}

	public void setTitle(Map<String,String> title) {
		this.title = title;
	}
}
