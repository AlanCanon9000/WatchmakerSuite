package net.richarddawkins.watchmaker.swing.pedigree.menu;

import java.awt.Component;
import java.awt.event.ActionEvent;

import javax.swing.Icon;

import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.morphview.MorphView;
import net.richarddawkins.watchmaker.swing.images.WatchmakerCursors;
import net.richarddawkins.watchmaker.swing.menu.SwingWatchmakerAction;
import net.richarddawkins.watchmaker.swing.pedigree.SwingPedigreeMorphView;

public class ActionPedigreeDetach  extends SwingWatchmakerAction {
    private static final long serialVersionUID = 4121419685469500509L;
    
    public ActionPedigreeDetach(AppData appData, String name, Icon icon) {
        super(appData, name, icon);
        this.appData = appData;
    }
    public ActionPedigreeDetach(AppData appData) {
        this(appData, "Detach", null);
    }
    
    @Override
    public void actionPerformed(ActionEvent arg0) {
        MorphView morphView = appData.getMorphViewsTabbedPane().getSelectedMorphView();
        if(morphView instanceof SwingPedigreeMorphView) {
            ((Component)morphView.getPanels().firstElement()).setCursor(WatchmakerCursors.detach);
        }       
    }
}