package com.dugking.Util;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;

public class UtilPython {
	public  static String executePython() throws IOException, InterruptedException {
		String result = "";
		 
        try {
            Process process = Runtime.getRuntime().exec("python D:\\demo.py" );
            
            InputStreamReader ir = new InputStreamReader(process.getInputStream(),"GBK");
            LineNumberReader input = new LineNumberReader(ir);
            result = input.readLine();
            input.close();
            ir.close();
            process.waitFor();
        } catch (Exception e) {
            System.out.println("调用python脚本并读取结果时出错：" + e.getMessage());
        }
        
        System.out.println(result);
		return result;
	}
	
	public  static String executePython(String cmd) throws IOException, InterruptedException {
		String result = "";
		 
        try {
            Process process = Runtime.getRuntime().exec(cmd );
            
            InputStreamReader ir = new InputStreamReader(process.getInputStream(),"GBK");
            LineNumberReader input = new LineNumberReader(ir);
            result = input.readLine();
            input.close();
            ir.close();
            process.waitFor();
        } catch (Exception e) {
            System.out.println("调用python脚本并读取结果时出错：" + e.getMessage());
        }
        
        System.out.println(result);
		return result;
	}
}
