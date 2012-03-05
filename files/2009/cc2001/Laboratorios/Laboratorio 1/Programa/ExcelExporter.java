import javax.swing.*;
import java.io.*;

public class ExcelExporter 
{	
	public ExcelExporter() { }
	
	public void exportTable(JTable tabla, File file) throws IOException {
			
			FileWriter out = new FileWriter(file);
			for(int i=0; i < tabla.getColumnCount(); i++) {
		out.write(tabla.getColumnName(i) + "\t");
			}
			out.write("\n");

			for(int i=0; i< tabla.getRowCount(); i++) {
		for(int j=0; j < tabla.getColumnCount(); j++) {
			out.write(tabla.getValueAt(i,j).toString()+"\t");
			}
			out.write("\n");
		}

		out.close();
	}
}