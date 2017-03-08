package net.richarddawkins.watchmaker.swing.array;

import java.beans.PropertyChangeListener;
import java.util.Vector;

import net.richarddawkins.watchmaker.album.Album;
import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.genebox.GeneBoxStrip;
import net.richarddawkins.watchmaker.geom.BoxManager;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.draw.BoxedMorphCollection;
import net.richarddawkins.watchmaker.morph.draw.MorphDrawer;
import net.richarddawkins.watchmaker.morphview.MorphView;
import net.richarddawkins.watchmaker.morphview.MorphViewPanel;
import net.richarddawkins.watchmaker.morphview.ScaleSlider;
import net.richarddawkins.watchmaker.morphview.array.ArrayMorphView;
import net.richarddawkins.watchmaker.swing.morphview.SwingMorphViewPanel;

public abstract class SwingArrayMorphViewPanel extends SwingMorphViewPanel
        implements ArrayMorphView {

    public SwingArrayMorphViewPanel(MorphView morphView,
            BoxedMorphCollection page) {
        super(morphView, page);
        // TODO Auto-generated constructor stub
    }

}
