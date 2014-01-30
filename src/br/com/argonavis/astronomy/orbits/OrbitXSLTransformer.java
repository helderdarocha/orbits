package br.com.argonavis.astronomy.orbits;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URLDecoder;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;

/**
 * Servlet implementation class OrbitXSLTransformer
 */
public class OrbitXSLTransformer extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private DocumentBuilderFactory factory;
	private DocumentBuilder builder;
	TransformerFactory transformerFactory;
	Transformer generator;
	Transformer serializer;
	private Document resultXML;
	private File sourceXMLFile;
	private File stylesheetFile;
	
	Source xmlSource;
	Source xslStyle;

	@Override
	public void init() throws ServletException {
		super.init();
		
		System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");

		// web.xml parameters
		String stylesheetFileString = this.getInitParameter("stylesheetFile");
		String sourceXMLFileString  = this.getInitParameter("sourceXMLFile");
		String xslWorkingDirectory  = this.getInitParameter("xslWorkingDirectory");
		String dataWorkingDirectory = this.getInitParameter("dataWorkingDirectory");
		stylesheetFile = new File(xslWorkingDirectory, stylesheetFileString);
		sourceXMLFile  = new File(dataWorkingDirectory, sourceXMLFileString);
		
		// DOM factory
		factory = DocumentBuilderFactory.newInstance();
        try {
			builder = factory.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			throw new ServletException(e);
		}
		
		// DOM trees for transformation
        try {
			xmlSource = new StreamSource(sourceXMLFile.toURI().toURL().toExternalForm());
			xslStyle  = new StreamSource(stylesheetFile.toURI().toURL().toExternalForm());
		} catch (IOException e) {
			throw new ServletException(e);
		}
		
        // Transform factory
        transformerFactory = TransformerFactory.newInstance();
        try {
			generator = transformerFactory.newTransformer(xslStyle);
			serializer = transformerFactory.newTransformer();
		} catch (TransformerConfigurationException e) {
			throw new ServletException(e);
		} 
	}



	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * Reads HTTP parameters and sets XSL parameter list
	 * @param request HTTPRequest
	 * @param response HTTPResponse
	 * @throws ServletException
	 * @throws IOException
	 * @throws  
	 */
	void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, String[]> xslParameters = request.getParameterMap();
		
		Document resultTree;
		try {
			resultTree = this.transformXSL(xslParameters);
		} catch (TransformerException e) {
			throw new ServletException(e);
		}
		
		ByteArrayOutputStream outBuffer = new ByteArrayOutputStream(4192000);		
		StreamResult outStream = new StreamResult(outBuffer);
		
		DOMSource svg = new DOMSource(resultTree);
		try {
			serializer.setOutputProperty(OutputKeys.ENCODING, "iso-8859-1");
			serializer.setOutputProperty(OutputKeys.METHOD, "xml");
			serializer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "-//W3C//DTD SVG 1.1//EN");
			serializer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg11.dtd");
			serializer.transform(svg, outStream);
		} catch (TransformerException e) {
			throw new ServletException(e);
		}
		
		PrintWriter out = response.getWriter();
		response.setContentType("image/svg+xml");
		response.setCharacterEncoding("iso-8859-1");
		
		out.write(outBuffer.toString("iso-8859-1"));

	}

	Document transformXSL(Map<String, String[]> parameterList) throws TransformerException, UnsupportedEncodingException {
		resultXML = builder.newDocument();
		DOMResult result    = new DOMResult(resultXML);
		
		generator.clearParameters();
		
		for(Map.Entry<String, String[]> entry: parameterList.entrySet()) {
			String value = entry.getValue()[0];
			if (value == null) {
				value = "";
		    }
			value = URLDecoder.decode(value, "iso-8859-1");
		    generator.setParameter(entry.getKey(), value);
		}
		
		generator.transform(xmlSource, result);
		
		return (Document) result.getNode();
	}
	
}
