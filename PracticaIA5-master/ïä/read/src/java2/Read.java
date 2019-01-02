package java2;

import java.io.*;
import java.util.TreeSet;

public class Read {

	public static void main(String[] args) {
		try {
			File file = new File("C:/Users/usuario_local/Documents/οδ/datos_app_clips.txt");
			FileWriter fileWriter = new FileWriter(file);
			fileWriter.write(readFile("C:/hlocal/workspace-4.7-64bits/read/src/java2/datosTratadosEliminados.csv"));
			fileWriter.flush();
			fileWriter.close();
			System.out.println("Finish");
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
	
	private static String converse(String mes) {
		switch(mes) {
		case "January": return "01";
		case "February": return "02";
		case "March": return "03";
		case "April": return "04";
		case "May": return "05";
		case "June": return "06";
		case "July": return "07";
		case "August": return "08";
		case "September": return "09";
		case "October": return "10";
		case "November": return "11";
		case "December": return "12";
		default: return null;
		}
	}
	private static String readFile(String file) throws IOException {
	    BufferedReader reader = new BufferedReader(new FileReader (file));
	    String         line = null;
	    StringBuilder  sb = new StringBuilder();
	    String         ls = System.getProperty("line.separator");
	    TreeSet<String> ts = new  TreeSet<>();
	    
	    try {
	    	sb.append("(deffacts apps_init\n");
	    	String first = reader.readLine();
	    	String[] firstInfo = first.split(";");
	    	//String formattedString = String.format("%.02f", Float.parseFloat(s));
	    	int j = 0;
	        while((line = reader.readLine()) != null) {
	        	if(false &&  j!=504) {
	        		++j;continue; }
	        	j=0;
	        	String[] lineInfo = line.split(";");
	        	sb.append("\t(aplicacion ");
	        	
	        	lineInfo[0] = lineInfo[0].replaceAll("\"", "");
	        	lineInfo[0]="\""+lineInfo[0]+"\"";
	        	
	        	
	        	
	        	lineInfo[7] = lineInfo[7].replaceAll(" ", "");
	        	lineInfo[5] = lineInfo[5].replaceAll("\\+", "");
	        	lineInfo[5] = lineInfo[5].replaceAll(",", "");
	        	ts.add(lineInfo[8] );
	        	if(!lineInfo[4].equals("Varies with device")) {
	        		/*File files = new File("datos_app_clips.out");
	    			FileWriter fileWriter = new FileWriter(files);
	    			fileWriter.write(lineInfo[4]);
	    			fileWriter.flush();*/
	        		//System.out.println(lineInfo[4]);
	        		Float f = Float.parseFloat(lineInfo[4].substring(0, lineInfo[4].length()-1));
	        		if(lineInfo[4].charAt(lineInfo[4].length()-1)=='M')
	        			f=f*1000000;
	        		else if(lineInfo[4].charAt(lineInfo[4].length()-1)=='k')
	        			f=f*1000;
	        		lineInfo[4]=Integer.toString(Math.round(f));
	        	}
	        	else {
	        		lineInfo[4]="-1";
	        	}
	        	
	        	if(!lineInfo[9].equals("Never")) {
	        		String[] fecha = lineInfo[9].split(" ");
	        		fecha[1] = fecha[1].replaceAll(",", "");
	        		lineInfo[9]=fecha[1]+"/"+converse(fecha[0])+"/"+fecha[2];
	        	}
	        	if(!lineInfo[10].equals("Varies with device")) {
	        		lineInfo[10] = lineInfo[10].split(" ")[0];
	        	}
	        	lineInfo[10] = "\""+lineInfo[10]+"\"";
	        	lineInfo[6] = lineInfo[6].replaceAll("\\$", "");
	        	if(lineInfo[2].equals("NaN")) lineInfo[2]="0";
	        	
	            for(int i=0; i< firstInfo.length; ++i) {
	            	sb.append("("+firstInfo[i]+" "+lineInfo[i]+") ");
	            }
	            sb.append(")\n");
	        }
	        
	        sb.append(")");
	        for(String s: ts) {
	        	System.out.print(s+" ");
	        }
	        return sb.toString();
	    } finally {
	        reader.close();
	    }
	}

}
