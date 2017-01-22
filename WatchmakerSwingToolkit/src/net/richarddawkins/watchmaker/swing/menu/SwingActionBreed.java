package net.richarddawkins.watchmaker.swing.menu;

import java.awt.event.ActionEvent;

import javax.swing.Icon;

import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.morph.Morph;

public class SwingActionBreed extends SwingWatchmakerAction  {

	private static final long serialVersionUID = 4121419685469500509L;
	
	public SwingActionBreed(AppData appData, String name, Icon icon) {
		super(appData, name, icon);
	}
	public SwingActionBreed(AppData appData) {
		super(appData, "Breed");
	}
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		Morph morph = appData.getMorphOfTheHour();
		appData.addBreedingMorphView(morph);
	}

}