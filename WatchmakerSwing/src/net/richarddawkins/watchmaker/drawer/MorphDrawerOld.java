package net.richarddawkins.watchmaker.drawer;

import java.awt.Graphics2D;

import net.richarddawkins.watchmaker.geom.LocatedMorph;
import net.richarddawkins.watchmaker.geom.swing.SwingPicDrawer;

public class MorphDrawerOld extends MorphDrawer {

	public MorphDrawerOld(SwingPicDrawer swingPicDrawer) {
        super(swingPicDrawer);
        // TODO Auto-generated constructor stub
    }

    @Override
	public void drawChildren(LocatedMorph locatedMorph, Graphics2D g2) {
		animate(locatedMorph, g2);
		swingPicDrawer.drawPic(g2, locatedMorph.getMorph().getPic());
	}
}