package net.richarddawkins.watchmaker.morphs.snail;

import java.awt.Dimension;
import java.awt.Graphics2D;

import net.richarddawkins.watchmaker.geom.Point;
import net.richarddawkins.watchmaker.geom.Rect;
import net.richarddawkins.watchmaker.morphs.Morph;
import net.richarddawkins.watchmaker.morphs.Person;
import net.richarddawkins.watchmaker.morphs.SimplePersonImpl;

public class SnailPersonImpl extends SimplePersonImpl implements SnailPerson, Cloneable {
  public static boolean sideView = false;

  double wOpening;

  public SnailPersonImpl(Morph morph) {
    mutagen = new SnailMutagen(this);
    this.morph = morph;
  }

  public double getwOpening() {
    return wOpening;
  }

  public void setwOpening(double wOpening) {
    this.wOpening = wOpening;
  }

  public double getdDisplacement() {
    return dDisplacement;
  }

  public void setdDisplacement(double dDisplacement) {
    this.dDisplacement = dDisplacement;
  }

  public double getsShape() {
    return sShape;
  }

  public void setsShape(double sShape) {
    this.sShape = sShape;
  }

  public double gettTranslation() {
    return tTranslation;
  }

  public void settTranslation(double tTranslation) {
    this.tTranslation = tTranslation;
  }

  public double getTranslationGradient() {
    return translationGradient;
  }

  public void setTranslationGradient(double translationGradient) {
    this.translationGradient = translationGradient;
  }

  public double getdGradient() {
    return dGradient;
  }

  public void setdGradient(double dGradient) {
    this.dGradient = dGradient;
  }

  public int getCoarsegraininess() {
    return coarsegraininess;
  }

  public void setCoarsegraininess(int coarsegraininess) {
    this.coarsegraininess = coarsegraininess;
  }

  public int getReach() {
    return reach;
  }

  public void setReach(int reach) {
    this.reach = reach;
  }

  public int getGeneratingCurve() {
    return generatingCurve;
  }

  public void setGeneratingCurve(int generatingCurve) {
    this.generatingCurve = generatingCurve;
  }

  public int getHandedness() {
    return handedness;
  }

  public void setHandedness(int handedness) {
    this.handedness = handedness;
  }

  public int getMutProb() {
    return mutProb;
  }

  public void setMutProb(int mutProb) {
    this.mutProb = mutProb;
  }

  /**
   * DDisplacement is not allowed to be less than zero or greater than 1.
   */
  public void addToDDisplacement(double summand) {
    dDisplacement += summand;
    if (dDisplacement < 0)
      dDisplacement = 0;
    if (dDisplacement > 1)
      dDisplacement = 1;
  }

  public void addToTTranslation(double summand) {
    tTranslation += summand;
  }

  public void flipHandedness() {
    handedness = -handedness;
  }

  double dDisplacement;
  double sShape;
  double tTranslation;
  double translationGradient;
  double dGradient;
  int coarsegraininess;
  int reach;
  int generatingCurve;
  int handedness;
  int mutProb;

  @Override
  public void setBasicType(int i) {
    // TODO Auto-generated method stub

  }

  @Override
  public void develop(Graphics2D g2, Dimension d, boolean zeroMargin) {
    SnailDeveloperImpl developer = new SnailDeveloperImpl();
    Rect box = new Rect(0,0, d.width, d.height);
    Point where = new Point();
    where.h = d.width / 2;
    where.v = d.height / 2;
    developer.develop(g2, this, where, box);

  }

  @Override
  public Person reproduce(Morph newMorph) {
    SnailPersonImpl child = new SnailPersonImpl(newMorph);
    child.wOpening = this.wOpening;
    child.dDisplacement = this.dDisplacement;
    child.sShape = this.sShape;
    child.tTranslation = this.tTranslation;
    child.coarsegraininess = this.coarsegraininess;
    child.reach = this.reach;
    child.generatingCurve = this.generatingCurve;
    child.translationGradient = this.translationGradient;
    child.dGradient = this.dGradient;
    child.handedness = this.handedness;
    child.getMutagen().mutate();
    return child;

  }


  void develop(Point where) {
  }

}
