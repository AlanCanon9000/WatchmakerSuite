package net.richarddawkins.watchmaker.swing.menu;

import java.awt.event.ActionEvent;

import javax.swing.Action;

import net.richarddawkins.watchmaker.geom.WatchmakerColor;

public class ActionSwitchPalette extends SwingWatchmakerAction {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public ActionSwitchPalette(String paletteName) {
        super(paletteName);
        
    }

    @Override
    public void actionPerformed(ActionEvent evt){
        WatchmakerColor.getInstance().switchToPalette((String)this.getValue(Action.NAME));
    }
}
