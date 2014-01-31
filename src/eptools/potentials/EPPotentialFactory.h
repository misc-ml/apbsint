/* -------------------------------------------------------------------
 * LHOTSE: Toolbox for adaptive statistical models
 * -------------------------------------------------------------------
 * Project source file
 * Module: eptools
 * Desc.:  Header class EPPotentialFactory
 * ------------------------------------------------------------------- */

#ifndef EPTOOLS_EPPOTENTIALFACTORY_H
#define EPTOOLS_EPPOTENTIALFACTORY_H

#if HAVE_CONFIG_H
#  include <config.h>
#endif

#include "src/eptools/potentials/EPScalarPotential.h"

//BEGINNS(eptools)
  /**
   * Provides factory method for supported 'EPScalarPotential'
   * subclasses. All these have to be registered here with a unique
   * ID.
   * <p>
   * Registration is static and compile-time, nothing fancy. The
   * subclass 'EPPotentialNamedFactory' also maintains the
   * association
   *   Name (string) -> ID (nonneg. int)
   * Here, Name is exposed towards interface and must not change,
   * while IDs may change internally.
   *
   * @author  Matthias Seeger
   * @version %I% %G%
   */
  class EPPotentialFactory
  {
  protected:
    // Internal constants (potential IDs)

    static const int potGaussian    =0;
    static const int potLaplace     =1;
    static const int potProbit      =2;
    static const int potHeaviside   =3;
    static const int potExponential =4;
    static const int potQuantRegress=5;
    static const int potGaussMixture=6;
    static const int potSpikeSlab   =7;
    static const int potLast        =7;

  public:
    // Public static methods

    static bool isValidID(int pid) {
      return (pid>=0 && pid<=potLast);
    }

    /**
     * Creates 'EPScalarPotential' object of correct type, given ID.
     * In 'pv', a valid initial parameter vector has to be passed. Use
     * 'createDefault' for default construction.
     *
     * @param pid Potential ID
     * @param pv  Initial parameter vector
     * @return    New object
     */
    static EPScalarPotential* create(int pid,const double* pv);

    /**
     * Creates 'EPScalarPotential' object of correct type, given ID. The
     * default constructor of the type is called. The type may require
     * construction parameters (see 'EPScalarPotential' header comments),
     * in which case 'pv' must point to these. Otherwise, 'pv' is ignored.
     *
     * @param pid Potential ID
     * @param pv  Construction parameters. Def.: 0
     * @return    New object
     */
    static EPScalarPotential* createDefault(int pid,const double* pv=0);
  };
//ENDNS

#endif
