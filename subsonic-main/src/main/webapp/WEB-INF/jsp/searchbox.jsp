<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="include.jsp" %>

<%--
  Display searchbox inline.

PARAMETERS
  action: The action to perform when the searchbox is submitted.
  value: The default placeholder value for the searchbox.
  @Optional title: Title for input field
  @Optional iconaction: The action to perform when the search icon is clicked.
--%>

<script type="text/javascript">
    
</script>

<c:choose>
    <c:when test="${not empty param.iconaction}">
        <c:set value="${param.iconaction}" var="iconaction"/>
    </c:when>
    <c:otherwise>
        <c:set value="javascript:if($('input', $(this).parent()).val() != '' && $('input', $(this).parent()).val() != '${param.value}') $('#searchForm')[0].submit()" var="iconaction"/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${not empty param.title}">
        <c:set value="${param.title}" var="title"/>
    </c:when>
    <c:otherwise>
        <c:set value="${param.value}" var="title"/>
    </c:otherwise>
</c:choose>
    

<span class="right">
    <form id="searchForm" method="post" action="${param.action}" target="main">
        <input type="text" id="searchFormQuery" name="query" title="${title}" class="inputWithIcon" value="${param.value}" placeholder="${param.value}" onClick="select();"
            onFocus="if(this.value=='${param.value}'){this.value='';}else{this.select();}"
            onBlur="if(this.value==''){this.value='${param.value}'; $(this).change();}" validation="required">
        <span class="ui-icon ui-icon-search right" onClick="${iconaction}"></span>
    </form>
</span>