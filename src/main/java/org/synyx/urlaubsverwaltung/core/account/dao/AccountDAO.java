
package org.synyx.urlaubsverwaltung.core.account.dao;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.synyx.urlaubsverwaltung.core.account.domain.Account;
import org.synyx.urlaubsverwaltung.core.person.Person;


/**
 * Repository for {@link org.synyx.urlaubsverwaltung.core.account.domain.Account} entities.
 *
 * @author  Aljona Murygina - murygina@synyx.de
 */
public interface AccountDAO extends CrudRepository<Account, Integer> {

    @Query("select x from Account x where YEAR(x.validFrom) = ?1 and x.person = ?2")
    Account getHolidaysAccountByYearAndPerson(int year, Person person);
}
