<!--${ClassName} Page, generated by EasyAuto -->
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ taglib uri="http://www.springframework.org/tags"  prefix="s"%>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro"%>

<%--  JavaScript  --%>

<script type="text/javascript">
	// ${ClsLabel} Namespace
	var ${ClassName} = {};
	$(function() {
		/*
		 * datagrid
		 */
		var dg = $("#${ClassName}DataGrid");

		// EasyUIEx datagrid
		$("#${ClassName}DataGrid").initDatagrid({
			/*
			 * CRUD URL
			 */
			url : "${ClassName}/list",
			saveUrl : "${ClassName}/save",
			updateUrl : "${ClassName}/update",
			destroyUrl : "${ClassName}/<#if mutipleDelete>deleteBatch<#else>delete</#if>",
			
			<#if Oid??>idField : "${Oid}",</#if> // Primary Key Field
			
			showHeaderContextMenu : true, // Datagrid header ContextMenu
			
			<#if pagination>pagination : true,<#else>pagination : false, </#if> // Pagination
			// pageSize: 10,
			// pageList: [10, 20, 30, 40, 50],
			
			//queryParams:{"rows":dg.datagrid("options").pageSize}, // Pagination query parameters
			
			checkbox : true,
			checkOnSelect : true,
			singleSelect : false,
			
			// clickEdit : true, //// Click to edit, EasyUI default is double click
			// autoSave : true, // // Auto save edit
			
			showMsg : true, // The action message is displayed
			
			<#if contextMenu>
			menuSelector : "#${ClassName}ContextMenu", // ContextMenu
			showContextMenu : true,</#if>
			
			sendRowDataPrefix : "", //send parameter name prefix
			
			successKey : "statusCode", //The success key returned by the server
			successValue : "200", //The success value returned by the server
			
			onLoadSuccess : function(data) {
			},
			
			// on double click
			onDblClickRow : function(rowIndex, rowData) {
				toEdit(rowData);
			}
			
			<#if mutipleDelete>,mutipleDelete : true, // Multiple rows are submitted for deletion
			mutipleDeleteProperty : "${Oid}" // Multiple rows to mention the attributes and values to the server, will not add sendRowDataPrefix prefix to support the use of an array to specify multiple attribute names
			</#if>
		});

		/*
		 * Functions
		 */
		<#if toolbar>
		// Search
		${ClassName}.doSearch = function() {
			dg.datagrid("load", {
				<#if Propertys??>
				<#list Propertys as item>
				<#assign info=item?split("#")>
				'${info[1]}' : $("#${ClassName?uncap_first}${info[1]?cap_first}").val()<#sep>,</#sep>
				</#list>
				</#if>
			});
		}
		
		// Clear all search conditions
		${ClassName}.clearAll = function() {
			$("#${ClassName}SearchForm")[0].reset();
			dg.datagrid("load", {
			});
		}
		</#if>
		
		<#if remove>
		// Destory
		${ClassName}.toDelete = function() {
			var rows = $("#${ClassName}DataGrid").datagrid('getSelections');
			if (rows) {
				dg.rowDelete(true, false, "statusCode", "200");
			} else {
				uiEx.msg("<s:message code="msg.choiceDeleteRow"></s:message>");
			}
		}
		</#if>
		
		<#if save>
		// Add
		${ClassName}.toAdd = function() {
			uiEx.resetForm("#${ClassName}AddForm");
			uiEx.openDialog("#${ClassName}AddDialog", "${ClsLabel}<s:message code="label.add"></s:message>");
		}
		</#if>
		
		<#if update>
		// Click button to edit
		${ClassName}.toEdit = function() {
			var row = $("#${ClassName}DataGrid").datagrid('getSelected');
			if (rows && rows.length && rows.length>0) {
				toEdit(row);
			} else {
				uiEx.msg("<s:message code="msg.choiceEditRow"></s:message>");
			}
		}
		// Open edit dialog	
		function toEdit(row) {
			uiEx.resetForm("#${ClassName}EditForm");
			uiEx.openDialog("#${ClassName}EditDialog", "${ClsLabel}<s:message code="label.edit"></s:message>");

			uiEx.loadForm("#${ClassName}EditForm", row, "");
		}
		</#if>

	});
</script>


<%-- 2. Page  DataGrid --%>
<table id="${ClassName}DataGrid" title="${ClsLabel}<s:message code="label.list"></s:message>" style="width: 100%" <#if toolbar>toolbar="#${ClassName}Toolbar"</#if> idField="${Oid}" rownumbers="true" fit="true" fitColumns="true" nowrap="false">
	<thead>
		<tr>
			<th field="ck" checkbox="true" width="50" sortable="true"><s:message code="label.chkbox"></s:message>
			<#if Autos??>
			<#list Autos as item>
			<#assign info=item?split("#")>
			<#if info[4]=="true">
			<th field="${info[0]}" width="50" sortable="true">${info[2]}</th>
			</#if>
			</#list>
			</#if>
		</tr>
	</thead>
</table>

<#if toolbar>
<%-- 3. ToolBar --%>
<div id="${ClassName}Toolbar">
	<div>
	<form action="" id="${ClassName}SearchForm" onsubmit="${ClassName}.doSearch();return false">
		<#if Propertys??>
		<#list Propertys as item>
		<#assign info=item?split("#")>
		<span>${info[4]}:</span> <input name="${info[1]}" id="${ClassName?uncap_first}${info[1]?cap_first}" class="easyui-textbox" /> 
		</#list>
		</#if>
		<#if search>
		<a class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="${ClassName}.doSearch()"><s:message code="label.search"></s:message></a>
		<a class="easyui-linkbutton" iconCls="icon-clear" plain="true" onclick="${ClassName}.clearAll()"><s:message code="label.clear"></s:message></a>
		<input type="submit" style="display: none;"/></#if>
	</form>
	</div>
	<#if save><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="${ClassName}.toAdd()"><s:message code="label.add"></s:message>${ClsLabel}</a></#if>
	<#if update><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="${ClassName}.toEdit()"><s:message code="label.edit"></s:message>${ClsLabel}</a></#if>
	<#if remove><a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="${ClassName}.toDelete()"><s:message code="label.delete"></s:message>${ClsLabel}</a></#if>
</div>
</#if>

<#if contextMenu>
<%-- 4. DataGrid ContextMenu --%>
<div id="${ClassName}ContextMenu" class="easyui-menu" style="width:120px;">
	<#if save><div onclick="${ClassName}.toAdd()" data-options="iconCls:'icon-add'"><s:message code="label.add"></s:message>${ClsLabel}</div></#if>
	<#if update><div onclick="${ClassName}.toEdit()" data-options="iconCls:'icon-edit'"><s:message code="label.edit"></s:message>${ClsLabel}</div></#if>
	<#if remove><div onclick="${ClassName}.toDelete()" data-options="iconCls:'icon-remove'"><s:message code="label.delete"></s:message>${ClsLabel}</div></#if>
</div>
</#if>

<%-- 5. Other dialog page --%>
<%@ include file="/WEB-INF/content/dialog/${Module}/${ClassName}Add.jsp"%>
<%@ include file="/WEB-INF/content/dialog/${Module}/${ClassName}Edit.jsp"%>
