package net.richarddawkins.watchmaker.swing.menu;

import java.awt.Component;
import java.awt.event.ActionEvent;

import javax.swing.Icon;

import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.morphview.MorphView;
import net.richarddawkins.watchmaker.swing.images.WatchmakerCursors;
import net.richarddawkins.watchmaker.swing.pedigree.SwingPedigreeMorphView;

public class ActionPedigreeMove  extends SwingWatchmakerAction {
    private static final long serialVersionUID = 4121419685469500509L;
    public ActionPedigreeMove(AppData appData, String name, Icon icon) {
        super(appData, name, icon);
        this.appData = appData;
    }
    public ActionPedigreeMove(AppData appData) {
        this(appData, "Move", null);
    }
    
    @Override
    public void actionPerformed(ActionEvent arg0) {
        MorphView morphView = appData.getMorphViewsTabbedPane().getSelectedMorphView();
        if(morphView instanceof SwingPedigreeMorphView) {
            ((Component)morphView.getPanels().firstElement()).setCursor(WatchmakerCursors.move);
        }       
    }
}
