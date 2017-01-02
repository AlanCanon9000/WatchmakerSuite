package net.richarddawkins.watchmaker.morphs.mono;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Rectangle;

import net.richarddawkins.watchmaker.geom.Point;
import net.richarddawkins.watchmaker.geom.Rect;
import net.richarddawkins.watchmaker.morphs.Morph;
import net.richarddawkins.watchmaker.morphs.Person;
import net.richarddawkins.watchmaker.morphs.Pic;
import net.richarddawkins.watchmaker.morphs.biomorph.Biomorph;
import net.richarddawkins.watchmaker.morphs.biomorph.BiomorphPersonImpl;
import net.richarddawkins.watchmaker.morphs.biomorph.CompletenessType;
import net.richarddawkins.watchmaker.morphs.biomorph.SpokesType;
import net.richarddawkins.watchmaker.morphs.biomorph.SwellType;

public class MonochromePersonImpl extends BiomorphPersonImpl implements MonochromePerson {

  MonochromePersonImpl(Morph morph) {
    setMorph(morph);
    setGene9Max(11);
    mutagen = new MonochromeMutagenImpl(this);
  }

  void tree(int x, int y, int lgth, int dir, int[] dx, int[] dy) {
    int thick;
    Pic pic = morph.getPic();
    int xnew, ynew;
    if (dir < 0)
      dir += 8;
    if (dir >= 8)
      dir -= 8;
    if (trickleGene < 1)
      trickleGene = 1;
    xnew = x + lgth * dx[dir] / trickleGene;
    ynew = y + lgth * dy[dir] / trickleGene;
    pic.margin.unionRect(new Rect(x, y, x, y)).unionRect(new Rect(xnew, ynew, xnew, ynew));
    // pic.margin.left = Math.min(pic.margin.left, x);
    // pic.margin.right = Math.max(pic.margin.right, x);
    // pic.margin.bottom = Math.max(pic.margin.bottom, y);
    // pic.margin.top = Math.min(pic.margin.top, y);
    // pic.margin.left = Math.min(pic.margin.left, xnew);
    // pic.margin.right = Math.max(pic.margin.right, xnew);
    // pic.margin.bottom = Math.max(pic.margin.bottom, ynew);
    // pic.margin.top = Math.min(pic.margin.top, ynew);

    if (dGene[8] == SwellType.Shrink)
      thick = lgth;
    else if (dGene[8] == SwellType.Swell)
      thick = 1 + gene[8] - lgth;
    else
      thick = 1;
    pic.picLine(x, y, xnew, ynew, thick * Globals.myPenSize, Color.BLACK);
    if (lgth > 1) {
      if (oddOne) {
        tree(xnew, ynew, lgth - 1, dir + 1, dx, dy);
        if (lgth < order)
          tree(xnew, ynew, lgth - 1, dir - 1, dx, dy);
      } else {
        tree(xnew, ynew, lgth - 1, dir - 1, dx, dy);
        if (lgth < order)
          tree(xnew, ynew, lgth - 1, dir + 1, dx, dy);
      }
    }
  }

  public Person reproduce(Morph newMorph) {
    MonochromePersonImpl child = new MonochromePersonImpl(newMorph);
    super.copy(child);
    child.getMutagen().mutate();
    return child;
  }

  void plugIn(int[] gene, int[] dx, int[] dy) {
    order = gene[8];
    dx[3] = gene[0];
    dx[4] = gene[1];
    dx[5] = gene[2];
    dy[2] = gene[3];
    dy[3] = gene[4];
    dy[4] = gene[5];
    dy[5] = gene[6];
    dy[6] = gene[7];
    dx[1] = -dx[3];
    dy[1] = dy[3];
    dx[0] = -dx[4];
    dy[0] = dy[4];
    dx[7] = -dx[5];
    dy[7] = dy[5];
    dx[2] = 0;
    dx[6] = 0;
  }

  /**
   * <h2>Margins</h2 The original Pascal Develop procedure adjusts the margin in this order.
   * <ul>
   * <li>At the top of the Develop routine, where, if ZeroMargin is specified, the margin is
   * initialized to an infinitesimal rectangle centered on the point where drawing is to take place;
   * </li>
   * <li>In the nested procedure Tree, where it is adjusted twice: one for the supplied starting
   * point for a line segment, and once for the end point of the line segment.</li>
   * <li>After the call to tree, the margin is checked to see if the centre drawing point is left of
   * the center of the margin, or right of it. If it is to the left of centre, the right hand side
   * of the margin is moved right so that the centre drawing point is at the centre of the margin.
   * Otherwise, the left side of the margin is moved to the left so that it will be at the centre
   * (this movement may be zero if it is already centered: the routine does not check to see if
   * nothing needs to be done.)
   * 
   * </li>
   * </ul>
   * 
   * Instead of DelayedDrawing, just pass in null if you don't want a call to Drawpic at the end.
   */
  public void develop(Graphics2D g2, Dimension d, boolean zeroMargin) {
    Pic pic = morph.getPic();
    int sizeWorry;
    int[] dx = new int[8];
    int[] dy = new int[8];
    int[] running = new int[9];
    Point oldHere;
    Point centre;
    int extraDistance;
    int incDistance;
    Point here = new Point(d.width / 2, d.height / 2);
    
    Globals.clipBoarding = false;
    if (zeroMargin) {
      pic.margin.left = here.h;
      pic.margin.right = here.h;
      pic.margin.top = here.v;
      pic.margin.bottom = here.v;
    }
    centre = (Point) here.clone();
    plugIn(gene, dx, dy);
    pic.zeroPic(here);
    if (segNoGene < 1)
      segNoGene = 1;
    if (dGene[9] == SwellType.Swell)
      extraDistance = trickleGene;
    else if (dGene[9] == SwellType.Shrink)
      extraDistance = -trickleGene;
    else
      extraDistance = 0;

    running = gene.clone();
    incDistance = 0;
    for (int seg = 0; seg < segNoGene; seg++) {
      oddOne = seg % 2 == 1;
      if (seg > 0) {
        oldHere = (Point) here.clone();
        here.v += (segDistGene + incDistance) / trickleGene;
        incDistance += extraDistance;
        int thick;
        if (dGene[8] == SwellType.Shrink)
          thick = gene[8];
        else
          thick = 1;
        pic.picLine(oldHere.h, oldHere.v, here.h, here.v, thick, Color.BLACK);
        for (int j = 0; j < 8; j++) {
          if (dGene[j] == SwellType.Swell)
            running[j] += trickleGene;
          else if (dGene[j] == SwellType.Shrink)
            running[j] -= trickleGene;
        }
        if (running[8] < 1)
          running[8] = 1;
        plugIn(running, dx, dy);
      }
      sizeWorry = segNoGene * (1 << gene[8]);
      if (sizeWorry > Globals.worryMax)
        gene[8]--;
      if (gene[8] < 1)
        gene[8] = 1;
      tree(here.h, here.v, order, 2, dx, dy);
    }
    if (centre.h - pic.margin.left > pic.margin.right - centre.h)
      pic.margin.right = centre.h + (centre.h - pic.margin.left);
    else
      pic.margin.left = centre.h - (pic.margin.right - centre.h);

    int upExtent = centre.v - pic.margin.top; // can be zero if biomorph goes down
    int downExtent = pic.margin.bottom - centre.v;
    if (spokesGene == SpokesType.NSouth || spokesGene == SpokesType.Radial
        || Globals.theMode == ModeType.Engineering) {
      // Obscurely necessary to cope with erasing last Rect in Manipulation}
      if (upExtent > downExtent)
        pic.margin.bottom = centre.v + upExtent;
      else
        pic.margin.top = centre.v - downExtent;
    }
    if (spokesGene == SpokesType.Radial) {
      int wid = pic.margin.right - pic.margin.left;
      int ht = pic.margin.bottom - pic.margin.top;
      if (wid > ht) {
        pic.margin.top = centre.v - wid / 2 - 1;
        pic.margin.bottom = centre.v + wid / 2 + 1;
      } else {
        pic.margin.left = centre.h - ht / 2 - 1;
        pic.margin.right = centre.h + ht / 2 + 1;
      }
    }
    pic.morph = this.morph;
    if (g2 != null) {
      pic.drawPic(g2, d, centre, morph);
      g2.setColor(Color.RED);
      Rectangle rectangle = pic.margin.toRectangle();
      g2.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
    }

  }

  public void makeGenes(int a, int b, int c, int d, int e, int f, int g, int h, int i) {
    for (int j = 0; j < 10; j++) {
      dGene[j] = SwellType.Same;
    }
    segNoGene = 1;
    segDistGene = 150;
    completenessGene = CompletenessType.Double;
    spokesGene = SpokesType.NorthOnly;
    trickleGene = Biomorph.TRICKLE;
    mutSizeGene = Biomorph.TRICKLE / 2;
    mutProbGene = 10;
    gene[0] = a;
    gene[1] = b;
    gene[2] = c;
    gene[3] = d;
    gene[4] = e;
    gene[5] = f;
    gene[6] = g;
    gene[7] = h;
    gene[8] = i;
  }

  /**
   * 
   */
  public void chess() {
    makeGenes(-Biomorph.TRICKLE, 3 * Biomorph.TRICKLE, -3 * Biomorph.TRICKLE, -3 * Biomorph.TRICKLE,
        Biomorph.TRICKLE, -2 * Biomorph.TRICKLE, 6 * Biomorph.TRICKLE, -5 * Biomorph.TRICKLE, 7);
  }

  public void basicTree() {
    makeGenes(-10, -20, -20, -15, -15, 0, 15, 15, 7);
    segNoGene = 2;
    segDistGene = 150;
    completenessGene = CompletenessType.Single;
    dGene[3] = SwellType.Shrink;
    dGene[4] = SwellType.Shrink;
    dGene[5] = SwellType.Shrink;
    dGene[8] = SwellType.Shrink;
    trickleGene = 9;
  }

  public void insect() {
    makeGenes(Biomorph.TRICKLE, Biomorph.TRICKLE, -4 * Biomorph.TRICKLE, Biomorph.TRICKLE,
        -Biomorph.TRICKLE, -2 * Biomorph.TRICKLE, 8 * Biomorph.TRICKLE, -4 * Biomorph.TRICKLE, 6);
  }
}