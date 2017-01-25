package net.richarddawkins.watchmaker.morphs.arthro.swing;

import java.awt.Graphics2D;

import net.richarddawkins.watchmaker.morphs.arthro.phenotype.ArthromorphDrawingPreferences;
import net.richarddawkins.watchmaker.morphs.arthro.phenotype.ArthromorphPic;
import net.richarddawkins.watchmaker.morphs.bio.geom.Lin;
import net.richarddawkins.watchmaker.morphs.bio.geom.Pic;
import net.richarddawkins.watchmaker.morphs.swing.SwingPicDrawer;
import net.richarddawkins.watchmaker.phenotype.Phenotype;

public class SwingArthromorphPicDrawer extends SwingPicDrawer {

	public SwingArthromorphPicDrawer() {
		drawingPreferences = new ArthromorphDrawingPreferences();
	}
	
	@Override
	public void drawPic(Object graphicsContext, Phenotype phenotype) {
		ArthromorphPic pic = (ArthromorphPic) phenotype;
		Graphics2D g2 = (Graphics2D) graphicsContext;

	}

	@Override
	protected void limb(Graphics2D g2, Pic pic, Lin limb) {
		// TODO Auto-generated method stub
		
	}

}