package br.com.argonavis.astronomy;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.text.CollationKey;
import java.text.Collator;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * Servlet implementation class XPathSearchServlet
 */
public class AutocompleteSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Document document;
	private XPath xPath;
	
	String[] dataArray;

	/**
	 * @return
	 * @see HttpServlet#HttpServlet()
	 */
	public void init() throws ServletException {
		super.init();
		
		System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
		
		try {
			String sourceXMLFileString  = this.getInitParameter("sourceXMLFile");
			String dataWorkingDirectory = this.getInitParameter("dataWorkingDirectory");
			File sourceXMLFile  = new File(dataWorkingDirectory, sourceXMLFileString);
			
			document = DocumentBuilderFactory.newInstance()
					.newDocumentBuilder().parse(sourceXMLFile.toURI().toURL().toExternalForm());
			xPath = XPathFactory.newInstance().newXPath();
			
			String expression = this.getInitParameter("xpathNomes");

			XPathExpression xpe = xPath.compile(expression);
			NodeList result = (NodeList)xpe.evaluate(document, XPathConstants.NODESET);
			List<String> resultList = new ArrayList<String>();
			
			System.out.println(result.getLength());
			
			if (result != null) {
				for(int i = 0; i < result.getLength(); i++) {
					Element element = (Element)result.item(i);
					resultList.add(element.getAttribute("nome"));
				}
			}
			
			dataArray = (String[])resultList.toArray(new String[] {});
			
			for (int i = 0; i < dataArray.length; i++)
				System.out.println(dataArray[i]);

		} catch (SAXException e) {
			throw new ServletException(e);
		} catch (IOException e) {
			throw new ServletException(e);
		} catch (ParserConfigurationException e) {
			throw new ServletException(e);
		} catch (XPathExpressionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);

	}
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);

	}
	protected void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String query = request.getParameter("term");
		List<String> nomes = new ArrayList<String>();
		if(query != null && query.trim().length() > 0) {
			query = URLDecoder.decode(query, "iso-8859-1");
		    nomes = getData(query);
		}
		System.out.println("term: " + query);
		System.out.println("itens: " + nomes.size());
		for(int i = 0; i < nomes.size(); i++) {
			System.out.print("\"" + nomes.get(i) + "\"");
			if(i < nomes.size() - 1) {
				System.out.print(", ");
			}
		}
		
		response.setContentType("text/html");
		response.setCharacterEncoding("iso-8859-1");
		PrintWriter out = response.getWriter();
		out.print("[");
		for(int i = 0; i < nomes.size(); i++) {
			out.print("\"" + nomes.get(i) + "\"");
			if(i < nomes.size() - 1) {
				out.print(", ");
			}
		}
		out.print("]");
	}
	

    public List<String> getData(String query) {
    	String queryKey = Normalizer.normalize(query, Normalizer.Form.NFD).replaceAll("[^\\p{ASCII}]", "");  
    	
    	System.out.println("querykey: " + queryKey);

        List<String> matched = new ArrayList<String>();

        for(int i=0; i < dataArray.length; i++) {
            String dataKey = Normalizer.normalize(dataArray[i], Normalizer.Form.NFD).replaceAll("[^\\p{ASCII}]", "");  
            if(dataKey.toLowerCase().startsWith(queryKey.toLowerCase())) {
                matched.add(dataArray[i]);
            }
        }
        return matched;
    }

}
