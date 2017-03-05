package net.richarddawkins.watchmaker.swing.menu;

import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.util.logging.Logger;

import javax.swing.KeyStroke;

import net.richarddawkins.watchmaker.app.AppData;

public class ActionAlbumAddBiomorph extends SwingWatchmakerAction {

    private static final long serialVersionUID = 4121419685469500509L;
    private static Logger logger = Logger.getLogger(
            "net.richarddawkins.watchmaker.swing.menu.ActionAlbumAddBiomorph");
    public ActionAlbumAddBiomorph(AppData appData) {
        super(appData, "Add Biomorph to Album", null, KeyStroke.getKeyStroke(KeyEvent.VK_A, 
                Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()));
    }
    
    @Override
    public void actionPerformed(ActionEvent arg0) {
        appData.addMorphToAlbum();
    }
     

}