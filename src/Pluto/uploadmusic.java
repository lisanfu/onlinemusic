package Pluto;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

public class uploadmusic extends ActionSupport {
	private File upload;
	private String uploadContentType;
	private String uploadFileName;
	private String savePath;
	public File getUpload() {
		return upload;
	}
	public void setUpload(File upload) {
		this.upload = upload;
	}
	public String getUploadContentType() {
		return uploadContentType;
	}
	public void setUploadContentType(String uploadContentType) {
		this.uploadContentType = uploadContentType;
	}
	public String getUploadFileName() {
		return uploadFileName;
	}
	public void setUploadFileName(String uploadFileName) {
		this.uploadFileName = uploadFileName;
	}
	public void setSavePath(String value) {
		this.savePath = value;
	}
	private String getSavePath() throws Exception {
		return ServletActionContext.getRequest().getRealPath(savePath);
	}
	
	public String execute() throws Exception {
		ServletActionContext.getResponse().setCharacterEncoding("GB2312");
		PrintWriter out = ServletActionContext.getResponse().getWriter();
		ServletActionContext.getResponse().setHeader("Pragma", "No-cache");
		ServletActionContext.getResponse().setHeader("Cache-Control",
				"no-cache");
		ServletActionContext.getResponse().setDateHeader("Expires", 0);

		//获取文件后缀
		String fileType = getUploadFileName().substring(getUploadFileName().lastIndexOf("."));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Date dt = new Date();
		Random rd = new Random();
		setUploadFileName(sdf.format(dt) + rd.nextInt(9999) + fileType);
		
		if ("audio/mpeg".equals(getUploadContentType())) {
			FileOutputStream fos = new FileOutputStream(getSavePath() + "\\"
					+ getUploadFileName());
			FileInputStream fis = new FileInputStream(getUpload());
			byte[] buffer = new byte[10240];
			int len = 0;
			while ((len = fis.read(buffer)) > 0) {
				fos.write(buffer, 0, len);
			}
			String filePath = "upload\\\\" + getUploadFileName();
			out.println(function.PlutoJump("上传成功，请认真填写歌曲内容！", "upload.jsp?path=" + filePath));

		} else {
			out.println(function.PlutoJump("文件类型必须为MP3！", "uploadmusic.jsp"));
		}
		return null;
	}
	
	
}
