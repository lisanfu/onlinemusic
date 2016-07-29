package Pluto;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {
	/**
	 * ��ݿ�������
	 */
	static private String strDriver = "com.mysql.jdbc.Driver";
	/**
	 * ��ݿ�l��url
	 */
	static private String strUrl = "jdbc:mysql://localhost:3306/music";
	/**
	 * ��ݿ�l���û���
	 */
	static private String strUser = "root";
	/**
	 * ��ݿ�l������
	 */
	static private String strPwd = "123456";
	/**
	 * connection ����
	 */
	private Connection conn = null;
	/**
	 * Statement������connection�������
	 */
	private Statement stmt = null;
	/**
	 * PreparedStatement������connection�������
	 */
	private PreparedStatement pstmt = null;
	/**
	 * ResultSet ���
	 */
	private ResultSet rs = null;
	/**
	 * @des �ྲ̬��ʼ���⣬װ����ݿ���
	 */
	static {
		try {
			Class.forName(strDriver);
		} catch (ClassNotFoundException ex) {
			System.out.println("Error load" + strDriver);
		}
	}

	public DBConnection() {
	}

	/**
	 * @des �����ݿ�l��
	 */
	private Connection getConnection() {
		try {
			if (conn == null || conn.isClosed())
				conn = DriverManager.getConnection(strUrl, strUser, strPwd);
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
		return conn;
	}

	/**
	 * @des �ر���ݿ�l��
	 */
	public void close() {
		try {
			if (rs != null) {
				rs.close();
				rs = null;
			}
			if (pstmt != null) {
				pstmt.close();
				pstmt = null;
			}
			if (conn != null) {
				conn.close();
				conn = null;
			}
		} catch (Exception ex) {
			System.err.println("close error:" + ex.getMessage());
		}
	}

	/**
	 * @des���sql ��ѯ
	 * @param sql
	 *            ��ѯ��sql���
	 * @return ResultSet(���)
	 */
	public ResultSet executeQuery(String sql) {
		try {
			pstmt = getConnection().prepareStatement(sql);
			rs = pstmt.executeQuery();
		} catch (SQLException ex) {
			System.err.println("query error:" + ex.getMessage());
		}
		return rs;
	}

	/**
	 * @des���sql ִ��
	 * @param sql
	 *            ִ�е�sql���
	 * @return �Ƿ���ȷ
	 */
	public boolean execute(String sql) {
		try {
			pstmt = getConnection().prepareStatement(sql);
			if (pstmt.execute()) {
				return true;
			}
		} catch (SQLException ex) {
			System.err.println("query error:" + ex.getMessage());
			return false;
		}
		return true;
	}

	/**
	 * @des ����
	 * @param ���µ�sql
	 *            ���
	 * @return int ���ؽ����Ӱ�������)
	 */
	public int executeUpdate(String sql) {
		int resultNum = 0;
		try {
			pstmt = getConnection().prepareStatement(sql);
			resultNum = pstmt.executeUpdate();
		} catch (SQLException ex) {
			System.err.println("update error:" + ex.getMessage());
		} finally {
		}
		return resultNum;
	}
}
