package com.dugking.mainRun;

import java.io.FileNotFoundException;
import java.io.IOException;

import com.dugking.Util.FileUtil;
import com.dugking.Util.GraphType;
import com.dugking.Util.ListUnion;
import com.dugking.manifold.LaplanceDug;

import Jama.Matrix;

public class DemoSmileMatrix {
	public static void main(String[] args) throws FileNotFoundException, IOException {
		int[] arr=new int[100];
		for (int i = 0; i < 100; i++) {
			arr[i]=i%3;
		}
		System.out.println(ListUnion.getCluster(arr));
	}
}
