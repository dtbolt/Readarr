﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<NzbDrone.Web.Models.DownloadSettingsModel>" %>

<script type="text/javascript">
    $(document).ready(function () {
        var options = {
            target: '#result',
            beforeSubmit: showRequest,
            success: showResponse,
            type: 'post',
            resetForm: false
        };
        $('#form').ajaxForm(options);
        selectDownloadOption(); //Load either SAB or Blackhole div
        $('#save_button').attr('disabled', '');
    });

    function selectDownloadOption() {
        var selected = $("input[name='UseBlackHole']:checked").val();

        if (selected == "True") {
            document.getElementById('blackhole').style.display = 'block';
            document.getElementById('sab').style.display = 'none';
        }

        else {
            document.getElementById('sab').style.display = 'block';
            document.getElementById('blackhole').style.display = 'none';
        }
    }

    function showRequest(formData, jqForm, options) {
        $("#result").empty().html('Saving...');
        $("#form :input").attr("disabled", true);
    }

    function showResponse(responseText, statusText, xhr, $form) {
        $("#result").empty().html(responseText);
        $("#form :input").attr("disabled", false);
    }

    $(".blackhole_radio").live("change", function () {
        selectDownloadOption(); //Load either SAB or Blackhole div
    });                
</script>

    <% Html.EnableClientValidation(); %>

<% using (Html.BeginForm("SaveDownloads", "Settings", FormMethod.Post, new { id = "form", name = "form" }))
       {%>
<%--<%: Html.ValidationSummary(true, "Unable to save your settings. Please correct the errors and try again.") %>--%>

    <fieldset>
        <legend>Download Settings</legend>
        <%--//Sync Frequency
        //Download Propers?
        //Retention
        //SAB Host/IP
        //SAB Port
        //SAB APIKey
        //SAB Username
        //SAB Password
        //SAB Category
        //SAB Priority--%>

            <fieldset class="sub-field">
                <legend>Usenet Variables</legend>

                <div class="config-section">
                    <div class="config-group">
                        <div class="config-title"><%= Html.LabelFor(m => m.SyncFrequency) %></div>
                        <div class="config-value"><%= Html.TextBoxFor(m => m.SyncFrequency)%></div>
                    </div>
                    <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SyncFrequency)%></div>
                </div>
                    
                <div class="config-section">
                    <div class="config-group">
                        <div class="config-title"><%= Html.LabelFor(m => m.DownloadPropers)%></div>
                        <div class="config-value"><%= Html.CheckBoxFor(m => m.DownloadPropers)%></div>
                    
                    </div>
                    <div class="config-validation"><%= Html.ValidationMessageFor(m => m.DownloadPropers)%></div>
                </div>

                <div class="config-section">
                    <div class="config-group">
                        <div class="config-title"><%= Html.LabelFor(m => m.Retention)%></div>
                        <div class="config-value"><%= Html.TextBoxFor(m => m.Retention)%></div>
                    </div>
                    <div class="config-validation"><%= Html.ValidationMessageFor(m => m.Retention)%></div>
                </div>
            </fieldset>

            <div>
                <div>
                    <b><%= Html.LabelFor(m => m.UseBlackHole) %></b>
                </div>
                <div>
                    <%= Html.RadioButtonFor(m => m.UseBlackHole, true, new { @class = "blackhole_radio" }) %>Blackhole
                </div>
                <div>
                    <%= Html.RadioButtonFor(m => m.UseBlackHole, false, new { @class = "blackhole_radio" })%>SABnzbd
                </div>
            </div>

            <div id="sab" style="display:none">
                <fieldset class="sub-field">
                    <legend>SABnzbd</legend>

                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.SabHost)%></div>
                            <div class="config-value"><%= Html.TextBoxFor(m => m.SabHost)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SabHost)%></div>
                    </div>

                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.SabPort)%></div>
                            <div class="config-value"><%= Html.TextBoxFor(m => m.SabPort)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SabPort)%></div>
                    </div>

                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.SabApiKey)%></div>
                            <div class="config-value"><%= Html.TextBoxFor(m => m.SabApiKey)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SabApiKey)%></div>
                    </div>

                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.SabUsername)%></div>
                            <div class="config-value"><%= Html.TextBoxFor(m => m.SabUsername)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SabUsername)%></div>
                    </div>

                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.SabPassword)%></div>
                            <div class="config-value"><%= Html.TextBoxFor(m => m.SabPassword)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SabPassword)%></div>
                    </div>

                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.SabTvCategory)%></div>
                            <div class="config-value"><%= Html.TextBoxFor(m => m.SabTvCategory)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SabTvCategory)%></div>
                    </div>

                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.SabTvPriority) %></div>
                            <div class="config-value"><%= Html.DropDownListFor(m => m.SabTvPriority, Model.PrioritySelectList)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.SabTvPriority)%></div>
                    </div>
                </fieldset>
            </div>

            <div id="blackhole" style="display:none">
                <fieldset class="sub-field">
                    <legend>Blackhole</legend>
                    <div class="config-section">
                        <div class="config-group">
                            <div class="config-title"><%= Html.LabelFor(m => m.BlackholeDirectory) %></div>
                            <div class="config-value"><%= Html.TextBoxFor(m => m.BlackholeDirectory)%></div>
                        </div>
                        <div class="config-validation"><%= Html.ValidationMessageFor(m => m.BlackholeDirectory)%></div>
                    </div>

                </fieldset>            
            </div>

            <input type="submit" id="save_button" value="Save" disabled="disabled" />
    
    <% } %>
    </fieldset>
<div id="result"></div>