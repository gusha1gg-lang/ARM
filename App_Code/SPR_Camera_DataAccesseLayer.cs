using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.Odbc;

public class SPR_Camera
{
    public int IDCAM_NAME { get; set; }
    public string Camera_Type { get; set; }
    public string Camera_Name { get; set; }
}
/// <summary>
/// Сводное описание для SPR_Camera_DataAccessLayer
/// </summary>
public class SPR_Camera_DataAccesseLayer
{
    public static List<SPR_Camera> GetAllCameras(string Camera_Type)
    {
        if (Camera_Type==null)
        {
            Camera_Type = "Analog";
        }
        List<SPR_Camera> listSPRCameras = new List<SPR_Camera>();
        string connSting = @"dsn=AsutpDB";
        string strSQL;
        strSQL = "SELECT IDCAM_NAME, Camera_Type, Camera_Name FROM SPR_CAMERA WHERE Camera_Type = ? ORDER BY Camera_Name"; //, ID_VID_CAM,SPR_CAMERA.Camera_Name,ID_CISCO, Video_Camera_all.Camera_Type, Video_Camera_all.IDCAM_NAME
        using (OdbcConnection conn = new OdbcConnection(connSting))
        {
            conn.Open();
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
           // OdbcParameter param = new OdbcParameter("@ShopID", ShopID);

            cmd.Parameters.Add("@Camera_Type", Camera_Type);
            OdbcDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                SPR_Camera sprCamera = new SPR_Camera();

                sprCamera.IDCAM_NAME = Convert.ToInt32(reader["IDCAM_NAME"]);
                sprCamera.Camera_Type = reader["Camera_Type"].ToString();
                sprCamera.Camera_Name = reader["Camera_Name"].ToString();

                listSPRCameras.Add(sprCamera);
            }
        }

        return listSPRCameras;
    }


	public SPR_Camera_DataAccesseLayer()
	{
		//
		// TODO: добавьте логику конструктора
		//
	}
}