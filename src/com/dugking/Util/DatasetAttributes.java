package com.dugking.Util;

import com.dugking.DTO.DatasetsAttr;

public class DatasetAttributes {
	public static DatasetsAttr getattributes(String datasetName) {
		DatasetsAttr model = new DatasetsAttr();
		if (datasetName.equals("3sources")) {
			model.setDesc(
					"3Sources is collected from three well-known online news sources and each is treated as one view. We select the 169 stories which are reported in all three sources. ");
			model.setUrl("http://mlg.ucd.ie/datasets/3sources.html");
			model.setClusterNum(6);
			model.setSamples(169);
		}
		else if (datasetName.equals("BBCSport")) {
			model.setDesc("BBCSport dataset see footnote 2 (BBCSport) consists of 544 documents collected from the BBC Sport website. Each document was split into two segments and was manually annotated with one of the five topical labels. ");
			model.setUrl("http://mlg.ucd.ie/datasets/segment.html");
			model.setClusterNum(5);
			model.setSamples(544);
		}
		else if (datasetName.equals("HW2sources")) {
			model.setDesc("This handwritten digits (0-9) data is from the UCI repository. The dataset consists of 2000 examples, with view-1 being the 76 Fourier coecients and view-2 being the 240 pixel averages in 2  3 windows.");
			model.setUrl("http://archive.ics.uci.edu/ml/datasets.html");
			model.setClusterNum(10);
			model.setSamples(2000);
		}
		else{
			model.setDesc("Œ¥ ‰»Î ˝æ›ºØ√˚≥∆....");
			model.setUrl(".....");
		}
		return model;
	}
}
