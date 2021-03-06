package org.synyx.urlaubsverwaltung.restapi.availability;

import org.joda.time.DateMidnight;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.synyx.urlaubsverwaltung.core.person.Person;
import org.synyx.urlaubsverwaltung.test.TestDataCreator;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


/**
 * @author  Timo Eifler - eifler@synyx.de
 */
public class AvailabilityServiceTest {

    private static final int DAYS_IN_TEST_DATE_RANGE = 8;

    private AvailabilityService availabilityService;

    private FreeTimeAbsenceProvider freeTimeAbsenceProvider;

    private Person testPerson;
    private DateMidnight testDateRangeStart;
    private DateMidnight testDateRangeEnd;
    private TimedAbsenceSpans timedAbsenceSpansMock;

    @Before
    public void setUp() {

        freeTimeAbsenceProvider = mock(FreeTimeAbsenceProvider.class);
        timedAbsenceSpansMock = mock(TimedAbsenceSpans.class);

        when(freeTimeAbsenceProvider.checkForAbsence(
                any(Person.class),
                any(DateMidnight.class)))
            .thenReturn(timedAbsenceSpansMock);

        availabilityService = new AvailabilityService(freeTimeAbsenceProvider);

        testPerson = TestDataCreator.createPerson();
        testDateRangeStart = new DateMidnight(2016, 1, 1);
        testDateRangeEnd = new DateMidnight(2016, 1, DAYS_IN_TEST_DATE_RANGE);
    }


    @Test
    public void ensureFetchesAvailabilityListForEachDayInDateRange() {

        availabilityService.getPersonsAvailabilities(testDateRangeStart, testDateRangeEnd, testPerson);

        verify(freeTimeAbsenceProvider, times(DAYS_IN_TEST_DATE_RANGE))
            .checkForAbsence(eq(testPerson), any(DateMidnight.class));
    }


    @Test
    public void ensureReturnsDayAvailabilityWithCalculatedPresenceRatio() {

        DateMidnight dayToTest = testDateRangeStart;

        BigDecimal expectedAvailabilityRatio = BigDecimal.ONE;

        when(timedAbsenceSpansMock.calculatePresenceRatio()).thenReturn(expectedAvailabilityRatio);

        AvailabilityList personsAvailabilities = availabilityService.getPersonsAvailabilities(dayToTest, dayToTest,
                testPerson);

        verify(timedAbsenceSpansMock, times(1)).calculatePresenceRatio();

        List<DayAvailability> availabilityList = personsAvailabilities.getAvailabilities();
        Assert.assertEquals("Wrong number of Availabilities returned", 1, availabilityList.size());

        DayAvailability availabilityOnDayToTest = availabilityList.get(0);
        Assert.assertEquals("Wrong TimedAbsenceSpans set on return object", timedAbsenceSpansMock,
            availabilityOnDayToTest.getTimedAbsenceSpans());
        Assert.assertEquals("Wrong availability ratio set on return object", expectedAvailabilityRatio,
            availabilityOnDayToTest.getAvailabilityRatio());
    }
}
