package com.webreach.mirth.model.bind;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.webreach.mirth.model.Transport;

public class TransportUnmarshaller {
	private Logger logger = Logger.getLogger(UserUnmarshaller.class);

	/**
	 * Returns a Transport object given an XML string representation.
	 * 
	 * @param source
	 * @return
	 * @throws UnmarshalException
	 */
	public Transport unmarshal(String source) throws UnmarshalException {
		logger.debug("unmarshalling transport from string");

		try {
			InputStream is = new ByteArrayInputStream(source.getBytes());
			DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
			docBuilderFactory.setNamespaceAware(true);
			Document document = docBuilderFactory.newDocumentBuilder().parse(is);
			return unmarshal(document);
		} catch (UnmarshalException e) {
			throw e;
		} catch (Exception e) {
			throw new UnmarshalException("Could not parse source.", e);
		}
	}

	/**
	 * Returns a Transport object given a Document representation.
	 * 
	 * @param document
	 * @return
	 * @throws UnmarshalException
	 */
	public Transport unmarshal(Document document) throws UnmarshalException {
		logger.debug("unmarshalling transport from document");
		
		if ((document == null) || (!document.getDocumentElement().getTagName().equals("transport"))) {
			throw new UnmarshalException("Document is invalid.");
		}

		Transport transport = new Transport();
		Element transportElement = document.getDocumentElement();

		transport.setName(transportElement.getAttribute("name"));
		transport.setType(Transport.Type.valueOf(transportElement.getAttribute("type")));
		transport.setDisplayName(transportElement.getAttribute("displayName"));
		transport.setClassName(transportElement.getAttribute("className"));
		transport.setProtocol(transportElement.getAttribute("protocol"));
		transport.setTransformers(transportElement.getAttribute("transformers"));

		return transport;
	}
}