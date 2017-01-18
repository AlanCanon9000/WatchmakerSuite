package net.richarddawkins.watchmaker.gui.menu;

import java.awt.event.ActionEvent;
import java.beans.PropertyChangeListener;

import javax.swing.AbstractAction;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

import net.richarddawkins.watchmaker.gui.ActionQuit;
import net.richarddawkins.watchmaker.gui.SwingAppData;
import net.richarddawkins.watchmaker.gui.SwingAppDataFactory;
import net.richarddawkins.watchmaker.gui.SwingAppDataFactoryService;
import net.richarddawkins.watchmaker.gui.WatchmakerTabbedPane;

public abstract class SimpleMenuBuilder implements MenuBuilder, PropertyChangeListener {

    protected SwingAppData swingAppData;

    @Override
    public SwingAppData getSwingAppData() {
		return swingAppData;
	}

    @Override
    public void setSwingAppData(SwingAppData swingAppData) {
		this.swingAppData = swingAppData;
	}

	public SimpleMenuBuilder(SwingAppData swingAppData) {
        this.swingAppData = swingAppData;
        swingAppData.addPropertyChangeListener(this);
        viewBoundingBoxes.setSelected(swingAppData.isShowBoundingBoxes());
    }

    protected void addFileQuitAction(JMenu menu) {
        menu.add(new JMenuItem(new ActionQuit(menu)));
    }

    public void buildMenu(JMenuBar menuBar) {
        menuBar.removeAll();
        menuBar.add(buildWatchmakerMenu());
    }


    protected JMenu buildWatchmakerMenu() {
        JMenu watchMakerMenu = new JMenu("Watchmaker");
        SwingAppDataFactory factory = 
        		SwingAppDataFactoryService.getInstance().getFactory("Dawkins' Morphs");
        for (String morphType : factory.getMorphTypes()) {
            WatchmakerTabbedPane frame = swingAppData.getFrame();
            factory.setMorphType(morphType);
            NewMorphTypeAction morphTypeAction = new NewMorphTypeAction(morphType, 
            		factory.getIcon(), frame);
            if(morphType.equals("Snails"))
                morphTypeAction.setEnabled(false);
            watchMakerMenu.add(morphTypeAction);
        }
        addFileQuitAction(watchMakerMenu);
        return watchMakerMenu;
    }

    protected JCheckBoxMenuItem viewBoundingBoxes = new JCheckBoxMenuItem(
            new AbstractAction("View Bounding Boxes") {
        /**
         * 
         */
        private static final long serialVersionUID = 1L;

        @Override
        public void actionPerformed(ActionEvent e) {
            swingAppData.setShowBoundingBoxes(viewBoundingBoxes.isSelected());
            /*
             * BreedingPanel breedingPanel =
             * config.getBreedingAndGeneBoxPanel().getBreedingPanel();
             * breedingPanel.repaint(); breedingPanel.revalidate();
             */
        }
    });


}
