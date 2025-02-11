package net.richarddawkins.watchmaker.morphs.mono.geom;

import net.richarddawkins.watchmaker.geom.Point;
import net.richarddawkins.watchmaker.geom.Rect;

public class MonoLin extends Lin implements Cloneable {
    public Integer thickness = 1; // 1..8
    public MonoLin(Point startPt, Point endPt, int thickness) {
        super(startPt, endPt);
        this.thickness = thickness;
    }
    
    @Override
    public MonoLin clone() {
        MonoLin clone = (MonoLin) super.clone();
        clone.thickness = thickness;
        return clone;
      }

    @Override
    public void expandMargin(Rect margin) {
        margin.expandPoint(startPt, thickness);
        margin.expandPoint(endPt, thickness);
    }
    
    public String toString() {
    	return super.toString() + " thickness: " + thickness;
    }


}
