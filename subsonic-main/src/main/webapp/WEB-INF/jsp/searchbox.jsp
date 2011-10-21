<span class="right">
    <form name="searchForm" id="searchForm" method="post" action="search.view" target="main" style="width:300px">
        <table bgcolor="#ffffff" cellpadding="0px" cellspacing="0px" style="width:300px;text-align:right">
            <tr>
                <td style="border-style:solid none solid solid;border-color:#849dbd;border-width:1px;">
                    <input class="searchboxquery" type="text" name="query" id="query" onClick="select();" value="<fmt:message key='search.query'/>"
                        onFocus="if(this.value=='<fmt:message key='search.query'/>'){this.value='';this.style.color='#000';}else{this.select();}"
                        onBlur="if(this.value==''){this.value='<fmt:message key='search.query'/>';this.style.color='b3b3b3';}">
                </td>
                <td style="border-style:solid solid solid none;border-color:#849dbd;border-width:1px;" width="24px" align="right">
                    <input class="searchboxsubmit" id="Submit" type="image" src="<spring:theme code='searchImage'/>" alt="${search}" title="${search}" align="absBottom" style="border-style:none" width="18px">
                </td>
            </tr>
        </table>
    </form>
</span>