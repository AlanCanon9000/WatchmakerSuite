package net.richarddawkins.watchmaker.gui.old;

import java.awt.Container;
import java.awt.Font;
import java.awt.FontFormatException;
import java.awt.GraphicsEnvironment;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Vector;

import javax.swing.JMenuBar;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.UIManager;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import net.richarddawkins.watchmaker.morph.common.MorphConfig;
import net.richarddawkins.watchmaker.morph.common.MorphConfigFactory;
import net.richarddawkins.watchmaker.morph.common.MorphType;
import net.richarddawkins.watchmaker.morph.common.MorphTypeNotSupportedException;

/**
 * Main window of the Watchmaker Suite application.
 * 
 * @author alan
 *
 */
public class WatchmakerGUI extends JPanel {

  Container container;
  
  public WatchmakerGUI(Container c) {
    this.container = c;
  };
  
  /**
  * 
  */
  private static final long serialVersionUID = 1L;

  private void initFonts() {
    try {
      Font font = Font.createFont(Font.TRUETYPE_FONT, WatchmakerGUI.class
          .getResourceAsStream("/net/richarddawkins/watchmaker/font/ChicagoFLF.ttf"));
      GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
      ge.registerFont(font);
      font = Font.createFont(Font.TRUETYPE_FONT, WatchmakerGUI.class
          .getResourceAsStream("/net/richarddawkins/watchmaker/font/virtue.ttf"));
      ge.registerFont(font);

    } catch (FontFormatException e) {
      
      e.printStackTrace();
    } catch (IOException e) {
    
    e.printStackTrace();
  }
    setUIFont(new javax.swing.plaf.FontUIResource(new Font("ChicagoFLF", Font.PLAIN, 12)));

  }

  private static void setUIFont(javax.swing.plaf.FontUIResource f) {
    Enumeration<Object> keys = UIManager.getDefaults().keys();
    while (keys.hasMoreElements()) {
      Object key = keys.nextElement();
      Object value = UIManager.get(key);
      if (value instanceof javax.swing.plaf.FontUIResource) {
        UIManager.put(key, f);
      }
    }
  }

  JMenuBar menuBar;

  public static WatchmakerGUI INSTANCE = null;
  
  public WatchmakerGUI(JMenuBar menuBar) throws Exception {
    if(WatchmakerGUI.INSTANCE != null) 
      throw new Exception("Cannot instantiate more than one WatchmakerGUI.");
    WatchmakerGUI.INSTANCE = this;
    this.menuBar = menuBar;
    initFonts();
    initComponents();
  }

  MorphConfigFactory factory = null;

  JTabbedPane tabbedPane = new JTabbedPane();

  protected Vector<MorphConfig> configs = new Vector<MorphConfig>();

  class TabChangeListener implements ChangeListener {
    public void stateChanged(ChangeEvent e) {
      MorphConfig config = configs.get(tabbedPane.getSelectedIndex());
      config.getMenuBuilder().buildMenu(menuBar);
      menuBar.repaint();
      
    }
  }

  private void initComponents() {

    this.add(tabbedPane);

    
    MorphType[] morphTypes = new MorphType[] { MorphType.MONOCHROME_BIOMORPH , 
      MorphType.COLOUR_BIOMORPH, MorphType.ARTHROMORPH };
    for (MorphType morphType : morphTypes) { // MorphType.values()
      MorphConfig config;
		try {
			config = MorphConfigFactory.getInstance(morphType, this).createConfig();
		    config.setContainer(tabbedPane);
		    BreedingPanelOld panel = config.getBreedingPanel();
		    tabbedPane.addTab(config.getName(), config.getIcon(), panel, config.getToolTip());
		    configs.add(config);
		} catch (MorphTypeNotSupportedException e) {
			
			e.printStackTrace();
		}
    }
    tabbedPane.addChangeListener(new TabChangeListener());
    tabbedPane.setSelectedIndex(0);
    configs.get(0).getMenuBuilder().buildMenu(menuBar);
  }

}