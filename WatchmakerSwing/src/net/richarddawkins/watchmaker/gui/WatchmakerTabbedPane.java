package net.richarddawkins.watchmaker.gui;

import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.JMenuBar;
import javax.swing.JTabbedPane;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import net.richarddawkins.watchmaker.morph.MorphConfig;
import net.richarddawkins.watchmaker.morph.MorphType;

public class WatchmakerTabbedPane extends JTabbedPane {

	private static Logger logger = Logger.getLogger("net.richarddawkins.watchmaker.gui.WatchmakerTabbedPane");

	protected JMenuBar jMenuBar;

	private static final long serialVersionUID = -9105080336982806166L;

	public WatchmakerTabbedPane(JMenuBar jMenuBar) {
		super();
		this.jMenuBar = jMenuBar;
		SwingAppDataFactoryService service = SwingAppDataFactoryService.getInstance();
		SwingAppDataFactory factory = service.getFactory("Dawkins' Morphs");
		for (MorphType morphType : MorphType.values()) {
			if (morphType != MorphType.SNAIL) {
				logger.log(Level.INFO, "Creating WatchmakerTabbedPane for " + morphType.toString());
				
						
				factory.setMorphType(morphType);
				
				SwingAppData swingAppData = factory.newSwingAppData();
				swingAppData.setFrame(this);
				addSwingAppData(swingAppData);
				
			}
		}
		if (this.getTabCount() != 0)
			changeToTab(0);
		addChangeListener(new TabChangeListener());
		setSelectedIndex(0);
	}



	protected Vector<SwingAppData> swingAppData = new Vector<SwingAppData>();

	public String uniquify(String name) {
		String newName = name;
		boolean unique = false;
		int counter = 0;
		while (!unique) {
			boolean found = false;
			for (SwingAppData appData : swingAppData) {
				if (newName.equals(appData.getName())) {
					found = true;
					break;
				}
			}
			if (found)
				newName = name + " " + ++counter;
			else
				unique = true;
		}
		return newName;
	}

	public void addSwingAppData(SwingAppData newSwingAppData) {
		logger.log(Level.INFO, "addSwingAppData " + newSwingAppData.getName());
		newSwingAppData.setName(uniquify(newSwingAppData.getName()));
		swingAppData.add(newSwingAppData);
		MorphConfig config = newSwingAppData.getMorphConfig();
		newSwingAppData.addDefaultMorphView();
		
		addTab(config.getName(), config.getIcon(), newSwingAppData.getMorphViewsTabbedPane(), config.getToolTip());
		setTabComponentAt(this.getTabCount() - 1, new WatchmakerTabComponent(this, config.getIcon(), config.getName()));

		setSelectedIndex(this.getTabCount() - 1);
	}

	public void changeToTab(int selectedIndex) {
		swingAppData.elementAt(selectedIndex).getMenuBuilder().buildMenu(jMenuBar);
	}

	class TabChangeListener implements ChangeListener {
		public void stateChanged(ChangeEvent e) {
			changeToTab(getSelectedIndex());
		}
	}
}