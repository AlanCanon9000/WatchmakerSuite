package net.richarddawkins.wm.morphs.mono;

import java.awt.event.ActionEvent;

import javax.swing.AbstractAction;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;

import net.richarddawkins.watchmaker.resourceloader.ClassicImageLoader;
import net.richarddawkins.wm.WatchmakerGUI;

public class AboutMonochromeAction extends AbstractAction {

  /**
   * 
   */
  private static final long serialVersionUID = 1L;

  public AboutMonochromeAction() {
    super("About Monochrome Biomorphs");
  }

  @Override
  public void actionPerformed(ActionEvent e) {
    JOptionPane.showMessageDialog(WatchmakerGUI.INSTANCE,
        new ImageIcon(
            ClassicImageLoader.getPicture("AboutBlindWatchmaker_PICT_26817_463x287").getImage()),
        "About Blind Watchmaker", JOptionPane.PLAIN_MESSAGE, null);
  }

}
