/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package annexe;

import bean.TypeObjet;
import java.sql.Connection;

/**
 *
 * @author Jocelyn
 *
 */

public class Unite extends TypeObjet{
    
    public Unite() {
        this.setNomTable("AS_UNITE");
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("UNT", "getSeqUnite");
        this.setId(makePK(c));
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
	 String[] valMotCles={"val"};
        return valMotCles;
    }
    private int equivalence;

    public int getEquivalence() {
        return equivalence;
    }

    public void setEquivalence(int equivalence) {
        this.equivalence = equivalence;
    }
}
