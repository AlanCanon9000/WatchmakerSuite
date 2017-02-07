package net.richarddawkins.watchmaker.morphs.arthro.genome.swing;

import net.richarddawkins.watchmaker.genebox.GeneBox;
import net.richarddawkins.watchmaker.genome.Gene;
import net.richarddawkins.watchmaker.swing.geneboxstrip.SwingGeneBoxStrip;

public class SwingArthromorphGeneBoxStrip extends SwingGeneBoxStrip {

	private static final long serialVersionUID = 550977251971215966L;
	
	@Override
	public GeneBox getGeneBoxForGene(Gene gene) {
		return new SwingAtomGeneBox();
	}
}
