package net.richarddawkins.watchmaker.morphview;

import java.beans.PropertyChangeListener;
import java.util.Vector;

import net.richarddawkins.watchmaker.geom.BoxedMorph;
import net.richarddawkins.watchmaker.geom.Dim;
import net.richarddawkins.watchmaker.geom.Point;
import net.richarddawkins.watchmaker.geom.Rect;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.draw.BoxedMorphCollection;

public interface MorphViewPanel extends PropertyChangeListener  {


    void addPropertyChangeListener(PropertyChangeListener listener);

    void autoScaleBasedOnMorphs();


    void clearMorphImages();


    void gainFocus();

    BoxedMorphCollection getBoxedMorphCollection();
    Object getCursor();
    Dim getDim();
//    boolean getIncludeChildrenInAutoScale();
    Morph getMorphOfTheHour();
    Vector<Morph> getMorphs();
    MorphView getMorphView();
    String getName();
    Object getPanel();
    Rect getSpecial();
    boolean isAutoScale();
    boolean isShowBoundingBoxes();
    void loseFocus();
    void paintMorphViewPanel(Object graphicsContext, Dim size);
    void processMouseClicked(Point point, Dim size);
    void processMouseDragged(Point watchmakerPoint, Dim watchmakerDim);
    void processMouseMotion(Point myPt, Dim size);
    void processMousePressed(Point watchmakerPoint, Dim watchmakerDim);
    void processMouseReleased(Point watchmakerPoint, Dim watchmakerDim);
    void removePropertyChangeListener(PropertyChangeListener listener);
    void repaint();
    void setAutoScale(boolean autoScale);
    void setBoxedMorphCollection(BoxedMorphCollection newValue);
    void initPanel();
    void setCursor(Object cursor);
    /**
     *  Initialize the cursor to the state appropriate for the MorphViewPanel, once
     *  its other initialization is complete.
     */
    
    void initCursor();
//    void setIncludeChildrenInAutoScale(boolean includeChildrenInAutoScale);
    void setName(String name);
    void setSelectedBoxedMorph(BoxedMorph newValue);

    void setShowBoundingBoxes(boolean showBoundingBoxes);

    void setSpecial(Rect newValue);

    void updateCursor();

}
