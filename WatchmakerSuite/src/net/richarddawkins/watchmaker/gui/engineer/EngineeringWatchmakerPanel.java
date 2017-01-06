package net.richarddawkins.watchmaker.gui.engineer;

import net.richarddawkins.watchmaker.gui.GeneBoxyWatchmakerPanel;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.MorphConfig;

public class EngineeringWatchmakerPanel extends GeneBoxyWatchmakerPanel {
	
	public EngineeringWatchmakerPanel(MorphConfig config, Morph morph) {
		super(config, "Hypodermic_PICT_03937_16x16", "Engineering", true);
		EngineeringPanel engineeringPanel = new EngineeringPanel(this);
		setCentrePanel(engineeringPanel);
		engineeringPanel.seed(morph);
	}

    @Override
    public Morph getMorphOfTheHour() {
    	EngineeringPanel engineeringPanel =  (EngineeringPanel) centrePanel;
    	return engineeringPanel.getBoxedMorphVector()
    			.getBoxedMorph(0)
    			.getMorph();
    }
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8224824610112892419L;

}