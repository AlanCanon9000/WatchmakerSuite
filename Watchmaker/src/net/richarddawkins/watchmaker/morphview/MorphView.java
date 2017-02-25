package net.richarddawkins.watchmaker.morphview;

import java.util.Vector;

import net.richarddawkins.watchmaker.album.Album;
import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.genome.Genome;
import net.richarddawkins.watchmaker.geom.Dim;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.draw.MorphDrawer;

public interface MorphView {

    
	String getIcon();
	void setIcon(String icon);

	AppData getAppData();

	String getToolTip();

	void setToolTip(String toolTip);
	void seed();
	Morph getMorphOfTheHour();
	String getName();
	void setName(String newName);
	void setShowBoxes(boolean showBoxes);
	void setMorphDrawer(MorphDrawer morphDrawer);
	void addSeedMorph(Morph morph);

	void setAppData(AppData appData);
	boolean isShowBoxes();
	MorphDrawer getMorphDrawer();
	Vector<MorphViewPanel> getPanels();
    void undo();
    void redo();
    void backup(boolean copyMorph);
    MorphViewPanel getSelectedPanel();
    void setSelectedPanel(MorphViewPanel selectedPanel);
    Album getAlbum();
    void setAlbum(Album album);
    void addPanel(MorphViewPanel panel);
    void removePanel(MorphViewPanel panel);
}