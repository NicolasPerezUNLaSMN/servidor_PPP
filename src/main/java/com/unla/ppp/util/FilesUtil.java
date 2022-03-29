package com.unla.ppp.util;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FilesUtil{
	
	private static String ruta = "/archivos/";

    // Devuelve el texto en base 64 del pdf.
	public static String encodeFile(String IN_FILE) throws IOException { 
		byte[] inFileBytes = Files.readAllBytes(Paths.get(IN_FILE));
		byte[] encoded = org.apache.commons.codec.binary.Base64.encodeBase64(inFileBytes);
		return new String(encoded);
	}
	
	// Crea el archivo pdf y devuelve donde quedo alojado
	public static String decodeFile(String fileBase64, String OUT_FILE) throws IOException {
		byte[] encoded = fileBase64.getBytes();
		byte[] decoded = org.apache.commons.codec.binary.Base64.decodeBase64(encoded);
		OUT_FILE = ruta + OUT_FILE;
		writeToFile(OUT_FILE, decoded);
		return OUT_FILE;
	}
	
    private static void writeToFile(String fileName, byte[] bytes) throws IOException {
        FileOutputStream fos = new FileOutputStream(fileName);
        fos.write(bytes);
        fos.flush();
        fos.close();
    }
	
}
