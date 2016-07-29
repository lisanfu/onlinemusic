package Pluto;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import javax.activation.FileTypeMap;

public class function {
	public function() {

	}
    public static boolean isInvalid(String value) {
        return (value == null || value.length() == 0);
    }
	public static String page(int page_num, int cur_page, int per_group,
			String base_url) {
		String page_val = "";
		int /* group_num, */cur_group, from, to, a, next, prev;
		base_url += (base_url.indexOf('?') != -1) ? '&' : '?';
		if (page_num < 1) {
			return page_val;
		} else if (page_num == 1) {
			return page_val = "1";
		}
		if ((cur_page - 1) % (per_group - 1) == 0) { // ��������һҳ
			cur_group = (cur_page - 1) / (per_group - 1) + 1;
		} else {
			cur_group = (int) Math.ceil((double) (cur_page - 1)
					/ (per_group - 1));
		}
		from = (cur_group - 1) * (per_group - 1) + 1;
		from = cur_group <= 1 ? 1 : from;
		to = from + per_group;
		to = to > page_num ? page_num + 1 : to;

		for (a = from; a < to; a++) {
			if (a != cur_page) {
				page_val += "<a href =javascript:dopage('" + base_url + "page="
						+ String.valueOf(a) + "');>" + String.valueOf(a) + "</a>";
			} else {
				page_val += "<span class=\"current\">" + String.valueOf(a)
						+ "</span>";
			}
		}
		next = cur_page + 1;
		prev = cur_page - 1;
		if (cur_page != page_num) {
			page_val += "<a href =javascript:dopage('" + base_url + "page=" + String.valueOf(next)
					+ "');>  Next  </a>";
			page_val += "<a href =javascript:dopage('" + base_url + "page="
					+ String.valueOf(page_num) + "');> >> </a>"; 
		}
		if (cur_page != 1) {
			page_val = "<a href =javascript:dopage('" + base_url + "page=" + prev + "');> Prev </a>"
					+ page_val;
			page_val = "<a href =javascript:dopage('" + base_url + "page=1');>  << </a>" + page_val; // ��ҳ
		}
		return page_val;
	}
	
	public static String page(int page_num, int cur_page, int per_group,
			String base_url,boolean noAJAX) {
		String page_val = "";
		int /* group_num, */cur_group, from, to, a, next, prev;
		base_url += (base_url.indexOf('?') != -1) ? '&' : '?';
		if (page_num < 1) {
			return page_val;
		} else if (page_num == 1) {
			return page_val = "1";
		}
		if ((cur_page - 1) % (per_group - 1) == 0) { // ��������һҳ
			cur_group = (cur_page - 1) / (per_group - 1) + 1;
		} else {
			cur_group = (int) Math.ceil((double) (cur_page - 1)
					/ (per_group - 1));
		}
		from = (cur_group - 1) * (per_group - 1) + 1;
		from = cur_group <= 1 ? 1 : from;
		to = from + per_group;
		to = to > page_num ? page_num + 1 : to;

		for (a = from; a < to; a++) {
			if (a != cur_page) {
				page_val += "<a href =" + base_url + "page="
						+ String.valueOf(a) + ">" + String.valueOf(a) + "</a>";
			} else {
				page_val += "<span class=\"current\">" + String.valueOf(a)
						+ "</span>";
			}
		}
		next = cur_page + 1;
		prev = cur_page - 1;
		if (cur_page != page_num) {
			page_val += "<a href =" + base_url + "page=" + String.valueOf(next)
					+ ">  Next  </a>";
			page_val += "<a href =" + base_url + "page="
					+ String.valueOf(page_num) + "> >> </a>"; 
		}
		if (cur_page != 1) {
			page_val = "<a href =" + base_url + "page=" + prev + "> Prev </a>"
					+ page_val;
			page_val = "<a href =" + base_url + "page=1>  << </a>" + page_val;
		}
		return page_val;
	}

	// MD5����
	private final static String[] hexDigits = { "0", "1", "2", "3", "4", "5",
			"6", "7", "8", "9", "a", "b", "c", "d", "e", "f" };

	public static String byteArrayToHexString(byte[] b) {
		StringBuffer resultSb = new StringBuffer();
		for (int i = 0; i < b.length; i++) {
			resultSb.append(byteToHexString(b[i]));
		}
		return resultSb.toString();
	}

	private static String byteToHexString(byte b) {
		int n = b;
		if (n < 0)
			n = 256 + n;
		int d1 = n / 16;
		int d2 = n % 16;
		return hexDigits[d1] + hexDigits[d2];
	}

	public static String MD5Encode(String origin) {
		String resultString = null;

		try {
			resultString = new String(origin);
			MessageDigest md = MessageDigest.getInstance("MD5");
			resultString = byteArrayToHexString(md.digest(resultString
					.getBytes()));
		} catch (Exception ex) {

		}
		return resultString;
	}

	public static String PlutoJump(String errorStr, String jumpTo) {
		String str = null;
		try {
			str = "<script language='javascript'>alert('" + errorStr
					+ "');location.href='" + jumpTo + "';</script>";
		} catch (Exception e) {
			str = "<script language='javascript'>alert('" + errorStr
					+ "');location.href='" + jumpTo + "';</script>";
		}
		return str;
	}

	public static int strToInt(String str) {
		int a = 0;
		try {
			a = Integer.parseInt(str);
		} catch (NumberFormatException e) {
			a = 0;
		}
		return a;
	}

	public static String fileType(File file) {
		FileTypeMap map = FileTypeMap.getDefaultFileTypeMap();
		return map.getContentType(file);
	}

	/**
	 * ��ȡԴ�ļ�����
	 * 
	 * @param filename
	 *            String �ļ�·��
	 * @throws IOException
	 * @return byte[] �ļ�����
	 */
	public static byte[] readFile(String filename) throws IOException {

		File file = new File(filename);
		if (filename == null || filename.equals("")) {
			throw new NullPointerException("��Ч���ļ�·��");
		}
		long len = file.length();
		byte[] bytes = new byte[(int) len];

		BufferedInputStream bufferedInputStream = new BufferedInputStream(
				new FileInputStream(file));
		int r = bufferedInputStream.read(bytes);
		if (r != len)
			throw new IOException("��ȡ�ļ�����ȷ");
		bufferedInputStream.close();

		return bytes;
	}
}
