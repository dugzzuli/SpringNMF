package com.dugking.Util;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class ListUnion {
	public static int getCluster(int[] arr){
		Map<Integer,Integer> map=new HashMap<Integer,Integer>();
		for (int i = 0; i < arr.length; i++) {
			map.put(arr[i], 1);
		}
		return map.size();
	}

	public static int getCluster(double[][] label) {
		Map<Integer,Integer> map=new HashMap<Integer,Integer>();
		for (int i = 0; i < label[0].length; i++) {
			int d=(int) label[0][i];
			map.put(d, 1);
		}
		return map.size();
	}
}
