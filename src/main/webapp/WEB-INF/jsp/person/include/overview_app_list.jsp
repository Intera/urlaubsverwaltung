<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<table class="list-table selectable-table">
    <tbody>
    <c:forEach items="${applications}" var="app" varStatus="loopStatus">
        <c:choose>
            <c:when test="${app.status == 'CANCELLED' || app.status == 'REJECTED'}">
                <c:set var="CSS_CLASS" value="inactive"/>
            </c:when>
            <c:otherwise>
                <c:set var="CSS_CLASS" value="active"/>
            </c:otherwise>
        </c:choose>
        <tr class="${CSS_CLASS}" onclick="navigate('${URL_PREFIX}/application/${app.id}');">
            <td class="visible-print">
                <span>
                    <spring:message code="${app.status}"/>
                </span>
            </td>
            <td class="is-centered state ${app.status} hidden-print">
                <span>
                     <c:choose>
                         <c:when test="${app.status == 'WAITING'}">
                             <i class="fa fa-question"></i>
                         </c:when>
                         <c:when test="${app.status == 'ALLOWED'}">
                             <i class="fa fa-check"></i>
                         </c:when>
                         <c:when test="${app.status == 'TEMPORARY_ALLOWED'}">
                             <i class="fa fa-check"></i>
                         </c:when>
                         <c:when test="${app.status == 'REJECTED'}">
                             <i class="fa fa-ban"></i>
                         </c:when>
                         <c:when test="${app.status == 'CANCELLED'}">
                             <i class="fa fa-trash"></i>
                         </c:when>
                         <c:otherwise>
                             &nbsp;
                         </c:otherwise>
                     </c:choose>
                </span>
            </td>
            <td>
                <h4 class="visible-print">
                    <spring:message code="${app.vacationType.messageKey}"/>
                </h4>
                <a class="hidden-print vacation ${app.vacationType.category}"
                   href="${URL_PREFIX}/application/${app.id}">
                    <h4>
                        <spring:message code="${app.vacationType.messageKey}"/>
                    </h4>
                </a>

                <p>
                    <c:choose>
                        <c:when test="${app.startDate == app.endDate}">
                            <spring:message code="${app.weekDayOfStartDate}.short"/>,
                            <uv:date date="${app.startDate}"/>,
                            <c:choose>
                                <c:when test="${app.startTime != null && app.endTime != null}">
                                    <c:set var="APPLICATION_START_TIME">
                                        <uv:time dateTime="${app.startDateWithTime}"/>
                                    </c:set>
                                    <c:set var="APPLICATION_END_TIME">
                                        <uv:time dateTime="${app.endDateWithTime}"/>
                                    </c:set>
                                    <spring:message code="absence.period.time"
                                                    arguments="${APPLICATION_START_TIME};${APPLICATION_END_TIME}"
                                                    argumentSeparator=";"/>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="${app.dayLength}"/>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <spring:message code="${app.weekDayOfStartDate}.short"/>, <uv:date date="${app.startDate}"/>
                            -
                            <spring:message code="${app.weekDayOfEndDate}.short"/>, <uv:date date="${app.endDate}"/>
                        </c:otherwise>
                    </c:choose>
                </p>
            </td>
            <td class="is-centered hidden-xs">
            <span>
                <c:choose>
                    <c:when test="${app.hours != null}">
                        <uv:number number="${app.hours}"/> <spring:message code="duration.overtime"/>
                    </c:when>
                    <c:otherwise>
                        <uv:number number="${app.workDays}"/> <spring:message code="duration.days"/>
                    </c:otherwise>
                </c:choose>
            </span>

                <c:if test="${app.startDate.year != app.endDate.year}">
                    <span class="days-${loopStatus.index}">
                        <%--is filled by javascript--%>
                        <script type="text/javascript">

                          $(document).ready(function () {

                              var dayLength = '<c:out value="${app.dayLength}" />';
                              var personId = '<c:out value="${app.person.id}" />';

                              var startDate = "<joda:format pattern='yyyy/MM/dd' value='${app.startDate}' />";
                              var endDate = "<joda:format pattern='yyyy/MM/dd' value='${app.endDate}' />";

                              var from = new Date(startDate);
                              var to = new Date(endDate);

                              sendGetDaysRequestForTurnOfTheYear("<spring:url value='/api' />", from, to, dayLength, personId, ".days-${loopStatus.index}");

                          });

                        </script>
                    </span>
                </c:if>
            </td>
            <td class="is-centered hidden-xs hidden-print">
                <i class="fa fa-clock-o"></i>
                <span>
                    <c:choose>
                        <c:when test="${app.status == 'WAITING'}">
                            <spring:message code="application.progress.APPLIED"/> <uv:date
                            date="${app.applicationDate}"/>
                        </c:when>
                        <c:when test="${app.status == 'TEMPORARY_ALLOWED'}">
                            <spring:message code="application.progress.TEMPORARY_ALLOWED"/> <uv:date
                            date="${app.editedDate}"/>
                        </c:when>
                        <c:when test="${app.status == 'ALLOWED'}">
                            <spring:message code="application.progress.ALLOWED"/> <uv:date date="${app.editedDate}"/>
                        </c:when>
                        <c:when test="${app.status == 'REJECTED'}">
                            <spring:message code="application.progress.REJECTED"/> <uv:date date="${app.editedDate}"/>
                        </c:when>
                        <c:when test="${app.status == 'CANCELLED' || app.status == 'REVOKED'}">
                            <spring:message code="application.progress.CANCELLED"/> <uv:date date="${app.cancelDate}"/>
                        </c:when>
                        <c:otherwise>
                            &nbsp;
                        </c:otherwise>
                    </c:choose>
                </span>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
