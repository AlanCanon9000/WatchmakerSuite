package net.richarddawkins.watchmaker.gui;

import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JPanel;

import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.MorphConfig;
import net.richarddawkins.watchmaker.resourceloader.ClassicImageLoader;

public abstract class MorphView extends JPanel {
	/**
	 * 
	 */
	MorphConfig config;
	
    public MorphConfig getMorphConfig() { return config; }
	public void setMorphConfig(MorphConfig config) { 
		this.config = config; 
	}
	
	private static final long serialVersionUID = 5555392236002752598L;
	protected Icon icon;
	protected String toolTip;
	
	public Icon getIcon() {
		return icon;
	}

	public void setIcon(Icon icon) {
		this.icon = icon;
	}

	public String getToolTip() {
		return toolTip;
	}

	public void setToolTip(String toolTip) {
		this.toolTip = toolTip;
	}
	protected void setIconFromFilename(String filename) {
		icon = new ImageIcon(ClassicImageLoader.getPicture(filename).getImage());
	}
	
	public Morph getMorphOfTheHour() {
		
		return null;
	}
}
