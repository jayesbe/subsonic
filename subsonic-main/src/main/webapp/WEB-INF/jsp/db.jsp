<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
        <script type="text/javascript">
            function fillBox(what) {
                document.forms[0].query.value = what.value;
                return false;
            }
            
            function dbQueryBuilder() {
                var action = document.getElementById("dbQueryAction").value;
                var table = document.getElementById("dbQueryTable").value;
                
                switch (action) {
                    case "SELECT":
                        document.dbQueryForm.query.value = action + " * FROM " + table; break;

                    case "UPDATE":
                        document.dbQueryForm.query.value = action + " " + table + " SET "; break;
                    
                    default:
                }
                
            }
            
            function verifySQLQuery() {
                var sql = document.dbQueryForm.query.value;
                
                // Check for null value
                if (sql == "") {
                    return false;
                }

                // Checks passed: submit
                document.dbQueryForm.submit();
            }
        </script>
    </head>

    <body class="mainframe bgcolor1">
        <fmt:message key="db.tables" var="dbtables"/>
        <fmt:message key="db.samples" var="samples"/>

        <div id="mainframecontainer">

            <div id="mainframemenucontainer" class="bgcolor1 fade">
                <span id="mainframemenuleft">
                    <span class="mainframemenuitem back cancel"><a href="more.view?"><fmt:message key="common.back"/></a></span>
                </span>
                <span id="mainframemenucenter">
                            <select id="dbQueryAction" onChange="dbQueryBuilder()">
                                <option value="SELECT">SELECT</option>
                                <option value="UPDATE">UPDATE</option>
                            </select>
                            <select id="dbQueryTable" onChange="dbQueryBuilder()">";
                            <c:forTokens items="${dbtables}" delims=" " var="dbtable">
                                <option ${dbtable eq model.query ? "selected" : ""} value="${dbtable}">${dbtable}</option>
                            </c:forTokens>
                            </select>
                </span>
                <span id="mainframemenuright">
                    <span class="mainframemenuitem forward right"><input id="runSQLQuery" type="button" value="Run" onClick="verifySQLQuery();"></span>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader">
                    </div>

                    <div id="dbQueryBuilder" class="fade" style="width:50%;margin: 0px auto; ">

                        <div>
                            <form name="dbQueryForm" method="post" action="db.view" name="query">
                                <textarea rows="7" cols="80" name="query" style="margin-top:1em">${model.query}</textarea>
                            </form>
                        </div>

                            <fmt:message key="db.sample" /><br>
                            ${samples}
                    </div>

                    <div id="dbQueryResults" class="fade" style="width:100%;margin:0px auto; overflow:auto; display: inline-block;">
                        <c:if test="${not empty model.result}">
                            <h1 style="margin-top:2em">Result</h1>

                            <table class="indent ruleTable">
                                <c:forEach items="${model.result}" var="row" varStatus="loopStatus">

                                    <c:if test="${loopStatus.count == 1}">
                                        <tr>
                                            <c:forEach items="${row}" var="entry">
                                                <td class="ruleTableHeader">${entry.key}</td>
                                            </c:forEach>
                                        </tr>
                                    </c:if>
                                    <tr>
                                        <c:forEach items="${row}" var="entry">
                                            <td class="ruleTableCell">${entry.value}</td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>

                            </table>
                        </c:if>

                        <c:if test="${not empty model.error}">
                            <h1 style="margin-top:2em">Error</h1>

                            <p class="warning">
                                ${model.error}
                            </p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>