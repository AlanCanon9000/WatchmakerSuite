package net.richarddawkins.watchmaker.swing.morphview;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Graphics;
import java.awt.GridBagLayout;
import java.awt.MouseInfo;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.Iterator;
import java.util.Vector;
import java.util.logging.Logger;

import javax.swing.BorderFactory;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSlider;
import javax.swing.SwingUtilities;

import net.richarddawkins.watchmaker.album.Album;
import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.genebox.GeneBoxStrip;
import net.richarddawkins.watchmaker.geom.BoxManager;
import net.richarddawkins.watchmaker.geom.BoxedMorph;
import net.richarddawkins.watchmaker.geom.BoxesDrawer;
import net.richarddawkins.watchmaker.geom.Dim;
import net.richarddawkins.watchmaker.geom.Point;
import net.richarddawkins.watchmaker.geom.Rect;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.draw.BoxedMorphCollection;
import net.richarddawkins.watchmaker.morph.draw.MorphDrawer;
import net.richarddawkins.watchmaker.morphview.MorphView;
import net.richarddawkins.watchmaker.morphview.MorphViewPanel;
import net.richarddawkins.watchmaker.phenotype.PhenotypeDrawer;
import net.richarddawkins.watchmaker.swing.SwingGeom;
import net.richarddawkins.watchmaker.swing.components.SwingScaleSlider;
import net.richarddawkins.watchmaker.swing.drawer.SwingMorphDrawer;

public abstract class SwingMorphView extends JPanel
        implements MorphView, PropertyChangeListener {
    private static Logger logger = Logger.getLogger(
            "net.richarddawkins.watchmaker.swing.morphview.SwingMorphView");

    private static final long serialVersionUID = 5555392236002752598L;
    protected AppData appData;
    protected BoxedMorphCollection boxedMorphCollection;

    protected final Vector<MorphViewPanel> panels = new Vector<MorphViewPanel>();
    protected String icon;
    protected Point lastMouseDown;
    protected Dim lastMouseDownSize;
    protected Point lastMouseDrag;
    protected Dim lastMouseDragSize;
    protected MorphDrawer morphDrawer;
    protected PropertyChangeSupport pcs = new PropertyChangeSupport(this);
    protected boolean showBoxes = true;
    protected Album album;
    protected String toolTip;
    public Rect special = null;
    public void undo() {}
    public void redo() {}
    public void backup(boolean copyMorph) {}
    
    @Override
    public void paintComponent(Graphics g) {
        logger.fine("SwingMorphView.paintComponent()");
        super.paintComponent(g);
    }
    
    public SwingMorphView(AppData appData, Album newAlbum, boolean engineeringMode) {
        this.appData = appData;
        
        this.setLayout(new BorderLayout());
        if(newAlbum != null) {
            this.album = newAlbum;
        } else {
            this.album = new Album("backing");
        }

        if(album.size() == 0) {
            boxedMorphCollection = new BoxedMorphCollection();
            if(! engineeringMode) {
                album.addPage(boxedMorphCollection);
            }
        } else {
            boxedMorphCollection = album.getPage(0);
        }
        
        this.panels.add(new SwingMorphViewPanel(this));    

        // this.setPreferredSize(new Dimension(640, 480));
        this.setBorder(BorderFactory.createLineBorder(Color.black));
        this.add((JPanel)panels.firstElement(), BorderLayout.CENTER);
        MouseAdapter mouseAdapter = new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                processMouseClicked(SwingGeom.toWatchmakerPoint(e.getPoint()),
                        SwingGeom.toWatchmakerDim(
                                ((Component) e.getSource()).getSize()));
            }

            @Override
            public void mouseDragged(MouseEvent e) {
                logger.info("mouseDragged");
                processMouseDragged(SwingGeom.toWatchmakerPoint(e.getPoint()),
                        SwingGeom.toWatchmakerDim(
                                ((Component) e.getSource()).getSize()));
            }

            @Override
            public void mouseMoved(MouseEvent e) {
                processMouseMotion(SwingGeom.toWatchmakerPoint(e.getPoint()),
                        SwingGeom.toWatchmakerDim(
                                ((Component) e.getSource()).getSize()));
            }

            @Override
            public void mousePressed(MouseEvent e) {
                logger.info("mousePressed");
                processMousePressed(SwingGeom.toWatchmakerPoint(e.getPoint()),
                        SwingGeom.toWatchmakerDim(
                                ((Component) e.getSource()).getSize()));
            }

            @Override
            public void mouseReleased(MouseEvent e) {
                logger.info("mouseReleased");
                processMouseReleased(SwingGeom.toWatchmakerPoint(e.getPoint()),
                        SwingGeom.toWatchmakerDim(
                                ((Component) e.getSource()).getSize()));
            }

        };
        ((Component)panels.firstElement()).addMouseListener(mouseAdapter);
        ((Component)panels.firstElement()).addMouseMotionListener(mouseAdapter);
        PhenotypeDrawer phenotypeDrawer = appData.getPhenotypeDrawer();
        morphDrawer = new SwingMorphDrawer(phenotypeDrawer);
        phenotypeDrawer.getDrawingPreferences().addPropertyChangeListener(this);

        SwingScaleSlider scaleSlider = new SwingScaleSlider(
                appData.getPhenotypeDrawer().getDrawingPreferences());

        this.add((JSlider) scaleSlider.getPanel(), BorderLayout.PAGE_END);
    }

    public SwingMorphView(AppData appData, String icon, String name, Album album, boolean engineeringMode) {
        this(appData, album, engineeringMode);
        this.setIcon(icon);
        this.setName(name);

    }

    public SwingMorphView(AppData appData, String icon, String name,
            boolean engineeringMode, boolean geneBoxToSide, Album album) {
        this(appData, icon, name, album, engineeringMode);
        GeneBoxStrip geneBoxStrip = appData.newGeneBoxStrip(engineeringMode);

        // So it can hear it when the selected genome changes.
        pcs.addPropertyChangeListener(geneBoxStrip);
        JPanel geneBoxStripPanel = (JPanel) geneBoxStrip.getPanel();
        geneBoxStripPanel.setLayout(new GridBagLayout());
        if (geneBoxToSide) {
            // Nassty nassty JScrollPane will center our content otherwise
            JPanel dummy = new JPanel();
            dummy.add(geneBoxStripPanel);
            JScrollPane scrollPane = new JScrollPane(dummy);
            this.add(scrollPane, BorderLayout.LINE_END);
        } else {
            this.add(geneBoxStripPanel, BorderLayout.PAGE_START);
        }

    }

    protected void processMouseClicked(Point point, Dim size) {

    }

    public AppData getAppData() {
        return appData;
    }

    @Override
    public BoxedMorphCollection getBoxedMorphCollection() {
        return boxedMorphCollection;
    }

    @Override
    public Vector<MorphViewPanel> getPanels() {
        return panels;
    }

    @Override
    public String getIcon() {
        return icon;
    }

    @Override
    public MorphDrawer getMorphDrawer() {
        return morphDrawer;
    }

    @Override
    public Morph getMorphOfTheHour() {
        return null;
    }

    @Override
    public Vector<Morph> getMorphs() {
        return boxedMorphCollection.getMorphs();
    }

    @Override
    public String getToolTip() {
        return toolTip;
    }

    @Override
    public boolean isShowBoxes() {
        return showBoxes;
    }

    /**
     * Draw boxes in box order (not in boxed Morph order.)
     * 
     * @param graphicsContext
     *            the abstract graphics context onto which subclasses should do
     *            their drawing.
     * @param size
     *            the current display size of the graphics context drawing area.
     */
    protected void drawBoxes(Object graphicsContext, Dim size) {
        BoxManager boxes = boxedMorphCollection.getBoxes();
        Vector<Integer> backgroundColors = new Vector<Integer>();
        Vector<BoxedMorph> boxedMorphs = boxedMorphCollection.getBoxedMorphs();
        for (int i = 0; i < boxes.getBoxCount(); i++) {
            BoxedMorph boxedMorph = boxedMorphCollection
                    .getBoxedMorph(boxes.getBox(i));
            if (boxedMorph != null) {
                backgroundColors.add(boxedMorph.getMorph().getPhenotype()
                        .getBackgroundColor());
            } else {
                backgroundColors.add(-1);
            }
        }

        BoxesDrawer boxesDrawer = appData.getBoxesDrawer();
        boolean midBoxOnly = boxedMorphCollection.getBoxedMorphs().size() == 1;
        boxesDrawer.draw(graphicsContext, size, boxes, midBoxOnly,
                backgroundColors);
    }

    @Override
    /**
     * Draw the MorphView's breeding box outlines (if showBoxes is set) and its
     * morphs, on the MorphView's centre panel.
     * 
     * Morph phenotypes have a background color, which PhenotypeDrawer instances
     * may use to fill the bounding rectangle of the morph. In order to also
     * paint the morph's background color within its breeding box, this
     * implementation iterates through the morph collection in box number order,
     * and builds a list of background colors to be passed to
     * BoxesDrawer.draw().
     * 
     */
    public synchronized void paintMorphViewPanel(Object graphicsContext,
            Dim size) {
        synchronized (boxedMorphCollection) {
            if (showBoxes) {
                drawBoxes(graphicsContext, size);
            }
            drawMorphs(graphicsContext, size);

        }
    }

    protected void drawMorphs(Object graphicsContext, Dim size) {

        int counter = 0;
        Iterator<BoxedMorph> iter = boxedMorphCollection.iterator();
        logger.fine("Boxed morphs to paint: "
                + boxedMorphCollection.getBoxedMorphs().size());
        while (iter.hasNext()) {
            logger.fine(
                    "SwingMorphView.paintMorphViewPanel() Getting BoxedMorph "
                            + counter);
            BoxedMorph boxedMorph = iter.next();
            morphDrawer.draw(boxedMorph, graphicsContext, size,
                    boxedMorph == this.boxedMorphCollection
                            .getSelectedBoxedMorph());
            counter++;
        }

    }

    protected void processMouseMotion(Point myPt, Dim size) {
    }

    protected void processMousePressed(Point watchmakerPoint,
            Dim watchmakerDim) {
        this.lastMouseDown = watchmakerPoint;
        this.lastMouseDownSize = watchmakerDim;

    }

    protected void processMouseDragged(Point watchmakerPoint,
            Dim watchmakerDim) {
        this.lastMouseDrag = watchmakerPoint;
        this.lastMouseDragSize = watchmakerDim;
        repaint();
    }

    protected void processMouseReleased(Point watchmakerPoint,
            Dim watchmakerDim) {
        this.lastMouseDown = null;
        this.lastMouseDownSize = null;
        this.lastMouseDrag = null;
        this.lastMouseDragSize = null;
        repaint();
    }

    public void propertyChange(PropertyChangeEvent event) {
        String propertyName = event.getPropertyName();
        if (propertyName.equals("showBoundingBoxes")
                || propertyName.equals("scale")
                || propertyName.equals("phenotype")) {
            logger.info("SwingMorphViewPanel propertyChange:" + propertyName);
            for (Morph morph : getMorphs()) {
                morph.setImage(null);
            }
            repaint();
        }
    }

    @Override
    public void setAppData(AppData appData) {
        this.appData = appData;
    }

    @Override
    public void setBoxedMorphCollection(BoxedMorphCollection boxedMorphVector) {
        this.boxedMorphCollection = boxedMorphVector;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    @Override
    public void setMorphDrawer(MorphDrawer morphDrawer) {
        this.morphDrawer = morphDrawer;
    }

    @Override
    public void setShowBoxes(boolean showBoxes) {
        this.showBoxes = showBoxes;
    }

    @Override
    public void setToolTip(String toolTip) {
        this.toolTip = toolTip;
    }

    @Override
    public void updateCursor() {
        java.awt.Point p = MouseInfo.getPointerInfo().getLocation();
        logger.info("Raw point " + p);
        SwingUtilities.convertPointFromScreen(p, (Component)panels.firstElement());
        logger.fine("Converted point " + p);
        if (p.x > -1 && p.y > -1) {
            Dim size = SwingGeom.toWatchmakerDim((((Component)panels.firstElement()).getSize()));
            logger.fine("processMouseMotion called");
            processMouseMotion(SwingGeom.toWatchmakerPoint(p), size);
            logger.fine("processMouseMotion returned");
        }

    }

}
