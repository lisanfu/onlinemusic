package Pluto;

import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.XMLOutputter;

import Pluto.DBConnection;
import Pluto.function;

public class creatXML {
	private String str = "3,2,4,5,6,7";
	private String [] playListArr;
	private String path;
	
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public void bulidXML(String [] id,HttpServletRequest request,String userName) throws IOException, JDOMException, SQLException {
		//创建XML头
		Element playList = new Element("playlist");;
		Document Doc = new Document(playList);
		playList = Doc.getRootElement();
		playList.setAttribute("version", "1");
		playList.setAttribute("xmln","http://xspf.org/ns/0/");
		Element title = new Element("title");
		title.setText("Pluto's Player");
		playList.addContent(title);
		//头结束
		
		Element trackList = new Element("trackList");
		playList.addContent(trackList);
		//trackList
		
		DBConnection conn  = new DBConnection();
		for(int i=0;i<id.length;i++){
			ResultSet rs = conn.executeQuery("select * from music where id = "+id[i]+"");
			rs.next();
			String music_title = rs.getString("title");
			String music_singer = rs.getString("singer");
			String music_url = rs.getString("url");
			Element track = new Element("track");
			Element annotation = new Element("annotation");
			annotation.setText(music_title + " - " + music_singer);
			track.addContent(annotation);
			Element location = new Element("location");
			location.setText("../" + music_url);
			track.addContent(location);
			trackList.addContent(track);
		}
		/*
		DBConnection conn  = new DBConnection();
		//根据ID选择music_box
		
		ResultSet rs = conn.executeQuery("select music_box from user where id = "+id+"");
		rs.next();
		str = rs.getString("music_box");
		if(function.isInvalid(str)){
			return ;
		}
		
		playListArr = str.split(",");
		//System.out.println(playListArr[1]);
		for(int i=0;i<=playListArr.length ;i++){
			//获取每首歌曲信息
			
			ResultSet listRS = conn.executeQuery("select * from music where id="+playListArr[i]+"");
			listRS.next();
			String music_title = listRS.getString("title");
			String music_singer = listRS.getString("singer");
			String music_url = listRS.getString("url");
			Element track = new Element("track");
			Element annotation = new Element("annotation");
			annotation.setText(music_title + " - " + music_singer);
			track.addContent(annotation);
			Element location = new Element("location");
			location.setText(music_url);
			track.addContent(location);
			trackList.addContent(track);
			
		}
		*/
		/*
		Element track = new Element("track");
		Element annotation = new Element("annotation");
		annotation.setText("Song");
		track.addContent(annotation);
		Element location = new Element("location");
		location.setText("http://127.0.0.1/2006113012325210077440240.mp3");
		track.addContent(location);
		trackList.addContent(track);

		*/
		
		ResultSet userRs = conn.executeQuery("select id from user where name = '"+userName+"'");
		userRs.next();
		String user_id = userRs.getString("id");
		
		XMLOutputter XMLOut = new XMLOutputter();
		XMLOut.output(Doc, new FileOutputStream(request.getSession().getServletContext().getRealPath("/player/xml/" + user_id + ".xml")));
	}
}
