<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Calendar.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;
	mso-font-charset:2;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:0 268435456 0 0 -2147483648 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
p
	{mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
span.apple-converted-space
	{mso-style-name:apple-converted-space;}
@page Section1
	{size:841.9pt 595.3pt;
	mso-page-orientation:landscape;
	margin:35.95pt 2.0cm 42.55pt 2.0cm;
	mso-header-margin:35.45pt;
	mso-footer-margin:35.45pt;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:73087149;
	mso-list-template-ids:-470891750;}
@list l0:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
@list l1
	{mso-list-id:921335215;
	mso-list-template-ids:309911768;}
@list l1:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
-->
</style>
<div style="margin:5px">
<div class=Section1>

<div align=center>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width="90%"
 style='width:90.0%;border-collapse:collapse;mso-padding-alt:2.25pt 2.25pt 2.25pt 2.25pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Январь<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Февраль<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=5 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Март<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td width=173 style='width:129.5pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Понедельник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>3<o:p></o:p></span></p>
  </td>
  <td style='background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>31<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;background:white;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Вторник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#444EFF'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Среда<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>30<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Четверг<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>3<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>3<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>31<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Пятница<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Суббота<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>1<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>8<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>15<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>22<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>29<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>5<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>12<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>19<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#444EFF'>5<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>12<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>19<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Воскресенье<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>2<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>9<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>16<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>23<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>30<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>6<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>13<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>20<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>27<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>6<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>13<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>20<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>27<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8'>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Апрель<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Май<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=5 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Июнь<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Понедельник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>30<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Вторник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>3<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>31<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Среда<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Четверг<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>30<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Пятница<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>3<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:14'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Суббота<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>2<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>9<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>16<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>23<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>30<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>7<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>14<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>21<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>28<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>4<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>11<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>18<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>25<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:15'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Воскресенье<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>3<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>10<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>17<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>24<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>1<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>8<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>15<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>22<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>29<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>12<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>19<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>26<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:16'>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Июль<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Август<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=5 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Сентябрь<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:17'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Понедельник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:18'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Вторник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>30<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:19'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Среда<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>3<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>31<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:20'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Четверг<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:21'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Пятница<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>30<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:22'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Суббота<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>2<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>9<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>16<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>23<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>30<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>6<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>13<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>20<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>27<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>3<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>10<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>17<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>24<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:23'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Воскресенье<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>3<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>10<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>17<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>24<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>31<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>7<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>14<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>21<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>28<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>4<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>11<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>18<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>25<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:24'>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Октябрь<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=6 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Ноябрь<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td colspan=5 style='background:#CFDAE9;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal align=center style='text-align:center'><span
  style='font-size:10.0pt'>Декабрь<o:p></o:p></span></p>
  </td>
  <td style='background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:25'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Понедельник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>3<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>31<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:26'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Вторник<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:27'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Среда<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>5<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>12<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>19<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>30<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:28'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Четверг<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>6<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>13<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>20<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>27<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#444EFF'>3<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>10<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>17<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>24<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>1<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>8<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>15<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>22<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>29<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:29'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>Пятница<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>7<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>14<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>21<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>28<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>4<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>11<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>18<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>25<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=29 style='width:21.4pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>2<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>9<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>16<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>23<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>30<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:30'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Суббота<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>1<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>8<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>15<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>22<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>29<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>5<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>12<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>19<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>26<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>3<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>10<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>17<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>24<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>31<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:31;mso-yfti-lastrow:yes'>
  <td width=173 style='width:129.5pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>Воскресенье<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.45pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>2<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>9<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>16<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>23<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>30<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>6<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>13<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>20<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>27<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=39 style='width:29.45pt;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td width=18 style='width:13.4pt;background:#F0F0F0;padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>4<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>11<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>18<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>25<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;color:#FF1833'>&nbsp;<o:p></o:p></span></p>
  </td>
  <td style='padding:2.25pt 2.25pt 2.25pt 2.25pt'>
  <p class=MsoNormal><span style='font-size:10.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
</table>

</div>

<ul type=disc>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l1 level1 lfo1;tab-stops:list 36.0pt'><strong><span
     style='font-family:Arial;color:#0000CC'>22</span></strong><span
     class=apple-converted-space><span style='font-family:Arial'>&nbsp;</span></span><span
     style='font-family:Arial'>- Предпраздничные дни, в которые
     продолжительность работы сокращается на один час.<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l1 level1 lfo1;tab-stops:list 36.0pt'><strong><span
     style='font-family:Arial;color:#FF3333'>3</span></strong><span
     class=apple-converted-space><span style='font-family:Arial'>&nbsp;</span></span><span
     style='font-family:Arial'>- Нерабочие праздничные дни<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l1 level1 lfo1;tab-stops:list 36.0pt'><strong><span
     style='font-family:Arial;color:#C10000'>23</span></strong><span
     class=apple-converted-space><span style='font-family:Arial'>&nbsp;</span></span><span
     style='color:windowtext'>- Выходные дни</span><span style='font-family:
     Arial'><o:p></o:p></span></li>
</ul>

<p style='margin-top:6.0pt;margin-right:0cm;margin-bottom:6.0pt;margin-left:
0cm;line-height:14.95pt'><span style='font-family:Arial;color:black'>Согласно
статье 112 ТК РФ нерабочими праздничными днями в Российской Федерации являются:<o:p></o:p></span></p>

<ul type=disc>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial'>1, 2, 3, 4 и 5 января — Новогодние каникулы;<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial'>7 января — Рождество Христово;<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial'>23 февраля — День защитника Отечества;<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial'>8 марта — Международный женский день;<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial'>1 мая — Праздник Весны и Труда;<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial'>9 мая — День Победы;<o:p></o:p></span></li>
 <li class=MsoNormal style='color:black;mso-margin-top-alt:auto;mso-margin-bottom-alt:
     auto;line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial'>12 июня — День России;<o:p></o:p></span></li>
 <li class=MsoNormal style='mso-margin-top-alt:auto;mso-margin-bottom-alt:auto;
     line-height:14.95pt;mso-list:l0 level1 lfo2;tab-stops:list 36.0pt'><span
     style='font-family:Arial;color:black'>4 ноября — День народного единства.</span><span
     lang=EN-US style='mso-ansi-language:EN-US'><o:p></o:p></span></li>
</ul>

</div>

</div>
</asp:Content>

