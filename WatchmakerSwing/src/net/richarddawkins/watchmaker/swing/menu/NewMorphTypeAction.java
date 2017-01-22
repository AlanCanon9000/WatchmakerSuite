package net.richarddawkins.watchmaker.swing.menu;

import java.awt.event.ActionEvent;

import javax.swing.AbstractAction;
import javax.swing.Icon;

import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.app.AppDataFactory;
import net.richarddawkins.watchmaker.app.AppDataFactoryService;
import net.richarddawkins.watchmaker.app.MultiMorphTypeTabbedPanel;
public class NewMorphTypeAction extends AbstractAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4736552636289435148L;
	
	protected MultiMorphTypeTabbedPanel pane;
	public NewMorphTypeAction(String morphType, Icon icon, 
			MultiMorphTypeTabbedPanel multiMorphTypeTabbedPanel) {
		super(morphType, icon);
		this.pane = multiMorphTypeTabbedPanel;
	}



	@Override
	public void actionPerformed(ActionEvent arg0) {
		AppDataFactory factory = 
		AppDataFactoryService.getInstance().getFactory();
		
		factory.setMorphType((String)this.getValue(NAME));
		AppData newSwingAppData = factory.newAppData();
		
		pane.addAppData(newSwingAppData);
		
	}
	
}