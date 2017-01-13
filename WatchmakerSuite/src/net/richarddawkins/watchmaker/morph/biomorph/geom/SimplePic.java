package net.richarddawkins.watchmaker.morph.biomorph.geom;

import java.awt.Color;

public abstract class SimplePic extends Pic {
  public final void picLine(int xx1, int yy1, int xx2, int yy2) {
    picLine(xx1, yy1, xx2, yy2, 1, Color.BLACK);
  }
  public final void picLine(int xx1, int yy1, int xx2, int yy2, int thick) {
    picLine(xx1, yy1, xx2, yy2, thick, Color.BLACK);
  }
  public final void picLine(int xx1, int yy1, int xx2, int yy2, Color color) {
    picLine(xx1, yy1, xx2, yy2, 1, color);
  }
}