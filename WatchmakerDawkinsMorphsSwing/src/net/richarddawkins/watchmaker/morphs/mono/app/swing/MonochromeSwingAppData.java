package net.richarddawkins.watchmaker.morphs.mono.app.swing;

import net.richarddawkins.watchmaker.genebox.GeneBoxStrip;
import net.richarddawkins.watchmaker.morphs.mono.MonochromeMorphConfig;
import net.richarddawkins.watchmaker.morphs.mono.genebox.swing.SwingMonochromeGeneBoxStrip;
import net.richarddawkins.watchmaker.morphs.mono.geom.swing.SwingMonoPicDrawer;
import net.richarddawkins.watchmaker.morphs.mono.menu.swing.SwingMonochromeMenuBuilder;
import net.richarddawkins.watchmaker.morphs.swing.MorphType;
import net.richarddawkins.watchmaker.swing.app.SwingAppData;
/**
 * Contains the factory methods required to create
 * and represent a Monochrome session.
 * @author Alan Canon
 *
 */
public class MonochromeSwingAppData extends SwingAppData  {
	public MonochromeSwingAppData() {
		setMenuBuilder(new SwingMonochromeMenuBuilder(this));
		setPhenotypeDrawer(new SwingMonoPicDrawer());
		this.setBreedRightAway(true);
		this.setIcon(MorphType.MONOCHROME_BIOMORPH.getIconFilename());
		this.setMorphConfig(new MonochromeMorphConfig());
	}
	@Override
	public GeneBoxStrip newGeneBoxStrip(boolean engineeringMode) {
		GeneBoxStrip geneBoxStrip = new SwingMonochromeGeneBoxStrip(this);
		geneBoxStrip.setEngineeringMode(engineeringMode);
		geneBoxStrip.setGeneBoxToSide(false);
		return geneBoxStrip;
	}


}
