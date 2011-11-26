<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="doctype.jsp" %>

<html>
    <head>
        <%@ include file="head.jsp" %>
        <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    </head>

    <body class="mainframe bgcolor1">
        <fmt:message key="db.tables" var="dbtables"/>
        <fmt:message key="db.samples" var="samples"/>

        <div id="mainframecontainer" class="fillframe">

            <div id="mainframemenucontainer" class="bgcolor1 fade vcenterouter fillwidth">
                <span id="mainframemenuleft" class="vcenterinner">
                    <button onClick="persistentTopLinks('more.view?')" class="ui-icon-triangle-1-w ui-icon-primary vcenter"><fmt:message key="common.back"/></button>
                </span>
                <span id="mainframemenucenter" class="vcenterinner">
                    <select id="dbQueryAction" onChange="dbQueryBuilder(this)" class="vcenter">
                        <option value="ACTION">ACTION</option>
                        <option value="SELECT">SELECT</option>
                        <option value="UPDATE">UPDATE</option>
                    </select>
                    <select id="dbQueryTable" onChange="dbQueryBuilder(this)" class="vcenter">";
                        <option value="TABLE">TABLE</option>
                    <c:forTokens items="${dbtables}" delims=" " var="dbtable">
                        <option ${dbtable eq model.query ? "selected" : ""} value="${dbtable}">${dbtable}</option>
                    </c:forTokens>
                    </select>
                </span>
                <span id="mainframemenuright" class="vcenterinner">
                    <button id="runSQLQuery" onClick="verifySQLQuery();" class="ui-icon-gear ui-icon-secondary vcenter right"><fmt:message key="db.run"/></button>
                </span>
            </div>

            <div id="mainframecontentcontainer">
                <div id="mainframecontent">
                    <div id="mainframecontentheader">
                    </div>

                    <div id="dbQueryBuilder" class="fade aligncenter">
                        <div style="margin-top:2em">
                            <select id="dbQuerySamples" onChange="dbQueryBuilder(this)">
                                <option value="SAMPLE"><fmt:message key="db.sample" /></option>
                            <c:forTokens items="${samples}" delims=";" var="query" varStatus="loopStatus">
                                <option value="${query}">${query}</option>
                            </c:forTokens>
                            </select>
                        </div>
                        <form id="dbQueryForm" name="dbQueryForm" method="post" action="db.view" name="query" class="inline" style="margin-top:2em">
                            <textarea rows="7" cols="80" name="query" validation="required" class="center">${model.query}</textarea>
                        </form>
                    </div>

                    <div id="dbQueryResults" class="fade inline fillwidth scroll">
                        <c:if test="${not empty model.result}">
                            <h1 style="margin-top:2em">Result</h1>

                            <table class="ruleTable center">
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
    <script type="text/javascript">
        function fillBox(val) {
            $("#dbQueryForm textarea").val(val);
        }
        
        function dbQueryBuilder(obj) {
            if (obj.selectedIndex == 0) {
                $("#dbQueryForm textarea").val("");
                return;
            }
            
            switch (obj.id) {
                case "dbQuerySamples":
                    $("#dbQueryAction")[0].selectedIndex = 0;
                    $("#dbQueryTable")[0].selectedIndex = 0;
                    $("#dbQueryForm textarea").val(obj.value);
                    return;
                default:
                    $("#dbQuerySamples")[0].selectedIndex = 0;
                    var action = $("#dbQueryAction").val();
                    var table = $("#dbQueryTable").val();
                    switch (action) {
                        case "SELECT": $("#dbQueryForm textarea").val(action + " * FROM " + table); break;
                        case "UPDATE": $("#dbQueryForm textarea").val(action + " " + table + " SET "); break;
                    }
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
        
        jQueryLoad.wait(function() {
            jQueryUILoad.wait(function() {
                $("#mainframemenucontainer").stylize();
                $("#dbQueryBuilder").validation().stylize();
            });
        });
    </script>
</html>