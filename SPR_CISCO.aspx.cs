using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string SPRType = Request.QueryString["SPRType"];
        if (SPRType == "1")
        {
            lb_Spr.Text = "Справочник CISCO";
            PanelCisco.Visible = true;
            PanelCamera.Visible = false;
        }
        else
        {
            lb_Spr.Text = "Справочник камер";
            PanelCisco.Visible = false;
            PanelCamera.Visible = true;
        }

    }

    protected void ImgBtnInsert_Click(object sender, EventArgs e)
    {
        int number_v;
        bool resultChek = false;

        string strProlet = ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_ProletCISCO")).Text;
        string strOC = ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_OC_CISCO")).Text;
        bool b_Prolet = Int32.TryParse(strProlet, out number_v);
        bool b_OC = Int32.TryParse(strOC, out number_v);
        if (strProlet == "" && strOC=="")
        {
            resultChek = true;

        }
        else
        {

            if (strProlet != "" && b_Prolet == true && strOC != "" && b_OC == true)
            {
                resultChek = true;
            }
            else
            {
                resultChek = false;
            }
        }
        

        if (resultChek)
        {
        ADS_CISCO.InsertParameters["IP_CISCO"].DefaultValue =
            ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_IPCISCO")).Text;
        ADS_CISCO.InsertParameters["Prolet_CISCO"].DefaultValue =strProlet;
        ADS_CISCO.InsertParameters["Oc_CISCO"].DefaultValue =
        ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_OC_CISCO")).Text;
        ADS_CISCO.InsertParameters["Location_CISCO"].DefaultValue =
        ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_Loc_CISCO")).Text;
        ADS_CISCO.InsertParameters["Opisanie_CISCO"].DefaultValue =
        ((TextBox)GV_CISCO.FooterRow.FindControl("TBox_ins_Opis_CISCO")).Text;
        ADS_CISCO.Insert();
        }
    }


    protected void ImgBtnInsertCameraType_Click(object sender, EventArgs e)
    {


        ADS_Camera.InsertParameters["Camera_Type"].DefaultValue =
            ((DropDownList)GV_CAMERA.FooterRow.FindControl("DDL_Camera_Type")).SelectedValue;
        ADS_Camera.InsertParameters["Camera_Name"].DefaultValue =
            ((TextBox)GV_CAMERA.FooterRow.FindControl("txtIns_CameraName")).Text;

        ADS_Camera.Insert();
    }
}