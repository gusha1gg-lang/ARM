using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.Odbc;

public class VideoCamera
{
    public int ID_VID_CAM { get; set; }
    public int IDCAM_NAME { get; set; }
    public int Oc { get; set; }
    public int Prolet { get; set; }
    public int ShopID { get; set; }
    public string Uchastok { get; set; }
    public string IPaddress { get; set; }
    public string Camera_number { get; set; }
    public string Camera_Name { get; set; }
    public string IP_Server_PC { get; set; }
    public string IP_CAMERA_STREAM { get; set; }
    public string Login_password { get; set; }
    public string CISCO { get; set; }
    public string Port_CISCO { get; set; }
    public string Video_out_lacation_PC { get; set; }
    public string Monitor { get; set; }
    public string Opisanie { get; set; }
    public int ID_CISCO { get; set; }
    public string IP_CISCO { get; set; }
    public int Prolet_CISCO { get; set; }
    public int Oc_CISCO { get; set; }
    public string Location_CISCO { get; set; }
    public string Opisanie_CISCO { get; set; }
    public string ShopName { get; set; }
    public string upload_img { get; set; }
    //<asp:Parameter Name="Oc" Type="Int32" />
    //    <asp:Parameter Name="Prolet" Type="Int32" />
    //    <asp:Parameter Name="ShopID" Type="Int32" />
    //    <asp:Parameter Name="Uchastok" Type="String" />
    //    <asp:Parameter Name="Camera_number" Type="String" />
    //    <asp:Parameter Name="IPaddress" Type="String" />
    //    <asp:Parameter Name="Login_password" Type="String" />
    //    <asp:Parameter Name="IP_Server_PC" Type="String" />
    //    <asp:Parameter Name="upload_img" Type="String" />
    //    <asp:Parameter Name="Opisanie" Type="String" />
    //    <asp:Parameter Name="Monitor" Type="String" />
    //    <asp:Parameter Name="Video_out_lacation_PC" Type="String" />
    //    <asp:Parameter Name="CISCO" Type="String" />
    //    <asp:Parameter Name="IP_CAMERA_STREAM" Type="String" />
    //    <asp:Parameter Name="Port_CISCO" Type="String" />
    //    <asp:Parameter Name="ID_VID_CAM" Type="Int32" />
    //    <asp:Parameter Name="IDCAM_NAME" Type="Int32" />
    //    <asp:Parameter Name="ID_CISCO" Type="Int32" />
    //    <asp:Parameter Name="Camera_Type" Type="String" />
}
/// <summary>
/// Сводное описание для VideoCameraDataAccesseLayer
/// </summary>
public class VideoCameraDataAccesseLayer
{
    public static List<VideoCamera> GetAllVideoCamera(int ShopID, int Prolet, string Camera_Type)
    {
        if (Camera_Type == null)
        {
            Camera_Type = "Analog";
        }
        List<VideoCamera> listVideoCameras = new List<VideoCamera>();
        string connSting = @"dsn=AsutpDB"; 
        string strSQL;
        strSQL = "SELECT ID_VID_CAM, Video_Camera_all.IDCAM_NAME, Oc, Prolet, Video_Camera_all.ShopID, Uchastok, IPaddress, Camera_number,SPR_CAMERA.Camera_Name, IP_Server_PC, IP_CAMERA_STREAM, Login_password, CISCO, Port_CISCO, Video_out_lacation_PC, Opisanie, Monitor, Video_Camera_all.ID_CISCO,IP_CISCO, Prolet_CISCO, Oc_CISCO, Location_CISCO, Opisanie_CISCO, ShopName, upload_img FROM Video_Camera_all,SPR_CAMERA,SPR_CISCO,NameShop WHERE ((Video_Camera_all.ShopID = ?) AND (Video_Camera_all.Prolet = ?) AND (Video_Camera_all.Camera_Type=?) AND (Video_Camera_all.IDCAM_NAME=SPR_CAMERA.IDCAM_NAME) AND (Video_Camera_all.ID_CISCO=SPR_CISCO.ID_CISCO) AND (Video_Camera_all.ShopID=NameShop.ShopID))"; //, ID_VID_CAM,SPR_CAMERA.Camera_Name,ID_CISCO, Video_Camera_all.Camera_Type, Video_Camera_all.IDCAM_NAME
        using (OdbcConnection conn = new OdbcConnection(connSting))
        {
            conn.Open();
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            OdbcParameter param = new OdbcParameter("@ShopID", ShopID);

            cmd.Parameters.Add("@ShopID", ShopID);
            cmd.Parameters.Add("@Prolet", Prolet);
            cmd.Parameters.Add("@Camera_Type", Camera_Type);
            OdbcDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                VideoCamera videoCamera = new VideoCamera();

                videoCamera.ID_VID_CAM = Convert.ToInt32(reader["ID_VID_CAM"]);
                videoCamera.IDCAM_NAME = Convert.ToInt32(reader["IDCAM_NAME"]);
                videoCamera.Oc = Convert.ToInt32(reader["Oc"]);
                videoCamera.Prolet = Convert.ToInt32(reader["Prolet"]);
                videoCamera.ShopID = Convert.ToInt32(reader["ShopID"]);
                videoCamera.Uchastok = reader["Uchastok"].ToString();
                videoCamera.IPaddress = reader["IPaddress"].ToString();
                videoCamera.Camera_number = reader["Camera_number"].ToString();
                videoCamera.Camera_Name = reader["Camera_Name"].ToString();
                videoCamera.IP_Server_PC = reader["IP_Server_PC"].ToString();
                videoCamera.IP_CAMERA_STREAM = reader["IP_CAMERA_STREAM"].ToString();
                videoCamera.Login_password = reader["Login_password"].ToString();
                videoCamera.CISCO = reader["CISCO"].ToString();
                videoCamera.Port_CISCO = reader["Port_CISCO"].ToString();
                videoCamera.Video_out_lacation_PC = reader["Video_out_lacation_PC"].ToString();
                videoCamera.Monitor = reader["Monitor"].ToString();
                videoCamera.Opisanie = reader["Opisanie"].ToString();
                videoCamera.ID_CISCO = Convert.ToInt32(reader["ID_CISCO"]);
                videoCamera.IP_CISCO = reader["IP_CISCO"].ToString();
                string s = reader["Prolet_CISCO"].ToString();
                if (reader["Prolet_CISCO"].ToString() == "")
                {
                    videoCamera.Prolet_CISCO = 0;
                }
                else
                {
                    videoCamera.Prolet_CISCO = Convert.ToInt32(reader["Prolet_CISCO"]);
                }
                if (reader["Oc_CISCO"].ToString()=="")
                {
                    videoCamera.Oc_CISCO = 0;
                }
                else
                {
                    videoCamera.Oc_CISCO = Convert.ToInt32(reader["Oc_CISCO"]);
                }

                videoCamera.Location_CISCO = reader["Location_CISCO"].ToString();
                videoCamera.Opisanie_CISCO = reader["Opisanie_CISCO"].ToString();
                videoCamera.ShopName = reader["ShopName"].ToString();
                videoCamera.upload_img = reader["upload_img"].ToString();
                listVideoCameras.Add(videoCamera);
            }
        }
        
        return listVideoCameras;
    }

    public static void DeleteVideoCamera(int ID_VID_CAM)
    { 
        string connSting = @"dsn=AsutpDB"; 
        
        using (OdbcConnection conn = new OdbcConnection(connSting))
        {
            string strSQL;
            strSQL = "DELETE FROM Video_Camera_all WHERE ID_VID_CAM = ?";
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            OdbcParameter param = new OdbcParameter("@ID_VID_CAM", ID_VID_CAM);
            
            cmd.Parameters.Add(param);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    public static void UpdateVideoCamera(int ID_VID_CAM, int IDCAM_NAME, int Oc, int Prolet, int ShopID, string Uchastok, string IPaddress, string Camera_number, string IP_Server_PC, string IP_CAMERA_STREAM, string Login_password, string CISCO, string Port_CISCO, string Video_out_lacation_PC, string Monitor, string Opisanie, int ID_CISCO, string upload_img)
    {
        string connSting = @"dsn=AsutpDB";

        if (String.IsNullOrEmpty(Opisanie)) Opisanie = "";
        if (String.IsNullOrEmpty(Uchastok)) Uchastok = "";
        if (String.IsNullOrEmpty(IPaddress)) IPaddress = "";
        if (String.IsNullOrEmpty(Camera_number)) Camera_number = "";
        if (String.IsNullOrEmpty(IP_Server_PC)) IP_Server_PC = "";
        if (String.IsNullOrEmpty(IP_CAMERA_STREAM)) IP_CAMERA_STREAM = "";
        if (String.IsNullOrEmpty(Login_password)) Login_password = "";
        if (String.IsNullOrEmpty(CISCO)) CISCO = "";
        if (String.IsNullOrEmpty(Port_CISCO)) Port_CISCO = "";
        if (String.IsNullOrEmpty(Video_out_lacation_PC)) Video_out_lacation_PC = "";
        if (String.IsNullOrEmpty(Monitor)) Monitor = "";
        if (String.IsNullOrEmpty(upload_img)) upload_img = "";
        
        using (OdbcConnection conn = new OdbcConnection(connSting))
        {
            string strSQL;
            strSQL = "UPDATE Video_Camera_all SET IDCAM_NAME=?, Oc=?, Prolet=?, ShopID=?, Uchastok=?, IPaddress=?, Camera_number=?, IP_Server_PC=?, IP_CAMERA_STREAM=?, Login_password=?, CISCO=?, Port_CISCO=?, Video_out_lacation_PC=?, Monitor=?, Opisanie=?, ID_CISCO=?, upload_img=? WHERE ID_VID_CAM=?";
           OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            //OdbcParameter param = new OdbcParameter("@ID_VID_CAM", ID_VID_CAM);

            cmd.Parameters.Add("@IDCAM_NAME", IDCAM_NAME);
            cmd.Parameters.Add("@Oc", Oc);
            cmd.Parameters.Add("@Prolet", Prolet);
            cmd.Parameters.Add("@ShopID", ShopID);
            cmd.Parameters.Add("@Uchastok", Uchastok);
            cmd.Parameters.Add("@IPaddress", IPaddress);
            cmd.Parameters.Add("@Camera_number", Camera_number);
            cmd.Parameters.Add("@IP_Server_PC", IP_Server_PC);
            cmd.Parameters.Add("@IP_CAMERA_STREAM", IP_CAMERA_STREAM);
            cmd.Parameters.Add("@Login_password", Login_password);
            cmd.Parameters.Add("@CISCO", CISCO);
            cmd.Parameters.Add("@Port_CISCO", Port_CISCO);
            cmd.Parameters.Add("@Video_out_lacation_PC", Video_out_lacation_PC);
            cmd.Parameters.Add("@Monitor", Monitor);
            cmd.Parameters.Add("@Opisanie", Opisanie);
            cmd.Parameters.Add("@ID_CISCO", ID_CISCO);
            cmd.Parameters.Add("@upload_img", upload_img);
            cmd.Parameters.Add("@ID_VID_CAM", ID_VID_CAM);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    public static void InsertVideoCamera(int IDCAM_NAME, int Oc, int Prolet, int ShopID, string Uchastok, string IPaddress, string Camera_number, string IP_Server_PC, string IP_CAMERA_STREAM, string Login_password, int ID_CISCO, string Port_CISCO, string Video_out_lacation_PC, string Monitor, string Opisanie, string upload_img, string Camera_Type)
    {
        string connSting = @"dsn=AsutpDB";
        //string Camera_Type = "IP";
        //int number_v;
        //bool resultChek = false;
        
        //string strProlet = ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_ProletCISCO")).Text;
        //string strOC = ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_OC_CISCO")).Text;
        //bool b_Prolet = Int32.TryParse(Oc, out number_v);
        //bool b_OC = Int32.TryParse(strOC, out number_v);

        if (String.IsNullOrEmpty(Opisanie)) Opisanie = "";
        if (String.IsNullOrEmpty(Uchastok)) Uchastok = "";
        if (String.IsNullOrEmpty(IPaddress)) IPaddress = "";
        if (String.IsNullOrEmpty(Camera_number)) Camera_number = "";
        if (String.IsNullOrEmpty(IP_Server_PC)) IP_Server_PC = "";
        if (String.IsNullOrEmpty(IP_CAMERA_STREAM)) IP_CAMERA_STREAM = "";
        if (String.IsNullOrEmpty(Login_password)) Login_password = "";
        if (String.IsNullOrEmpty(Port_CISCO)) Port_CISCO = "";
        if (String.IsNullOrEmpty(Video_out_lacation_PC)) Video_out_lacation_PC = "";
        if (String.IsNullOrEmpty(Monitor)) Monitor = "";
        if (String.IsNullOrEmpty(upload_img)) upload_img = "";
        using (OdbcConnection conn = new OdbcConnection(connSting))
        {
            string strSQL;
            strSQL = "INSERT INTO [Video_Camera_all] ([IDCAM_NAME], [Oc], [Prolet], [ShopID], [Uchastok], [Camera_number], [IPaddress], [Login_password], [IP_Server_PC], [IP_CAMERA_STREAM], [Port_CISCO], [Video_out_lacation_PC], [Monitor], [Opisanie], [ID_CISCO], [Camera_Type], [upload_img]) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            //strSQL = "INSERT Video_Camera_all SET IDCAM_NAME=?, Oc=?, Prolet=?, ShopID=?, Uchastok=?, IPaddress=?, Camera_number=?, IP_Server_PC=?, IP_CAMERA_STREAM=?, Login_password=?, CISCO=?, Port_CISCO=?, Video_out_lacation_PC=?, Monitor=?, Opisanie='?' WHERE ID_VID_CAM=?";
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            //OdbcParameter param = new OdbcParameter("@ID_VID_CAM", ID_VID_CAM);

            cmd.Parameters.Add("@IDCAM_NAME", IDCAM_NAME);
            cmd.Parameters.Add("@Oc", Oc);
            cmd.Parameters.Add("@Prolet", Prolet);
            cmd.Parameters.Add("@ShopID", ShopID);
            cmd.Parameters.Add("@Uchastok", Uchastok);
            cmd.Parameters.Add("@Camera_number", Camera_number);
            cmd.Parameters.Add("@IPaddress", IPaddress);
            cmd.Parameters.Add("@Login_password", Login_password);
            cmd.Parameters.Add("@IP_Server_PC", IP_Server_PC);
            cmd.Parameters.Add("@IP_CAMERA_STREAM", IP_CAMERA_STREAM);
            cmd.Parameters.Add("@Port_CISCO", Port_CISCO);
            cmd.Parameters.Add("@Video_out_lacation_PC", Video_out_lacation_PC);
            cmd.Parameters.Add("@Monitor", Monitor);
            cmd.Parameters.Add("@Opisanie", Opisanie);
            cmd.Parameters.Add("@ID_CISCO", ID_CISCO);
            cmd.Parameters.Add("@Camera_Type", Camera_Type);
            cmd.Parameters.Add("@upload_img", upload_img);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }
    public VideoCameraDataAccesseLayer()
	{
		//
		// TODO: добавьте логику конструктора
		//
	}
}