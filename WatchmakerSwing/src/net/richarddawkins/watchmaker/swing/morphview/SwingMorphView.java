package net.richarddawkins.watchmaker.swing.morphview;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Graphics;
import java.awt.Graphics2D;
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

import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.genebox.GeneBoxStrip;
import net.richarddawkins.watchmaker.geom.BoxManager;
import net.richarddawkins.watchmaker.geom.BoxedMorph;
import net.richarddawkins.watchmaker.geom.BoxesDrawer;
import net.richarddawkins.watchmaker.geom.Dim;
import net.richarddawkins.watchmaker.geom.Point;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.draw.BoxedMorphCollection;
import net.richarddawkins.watchmaker.morph.draw.MorphDrawer;
import net.richarddawkins.watchmaker.morphview.MorphView;
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
    protected BoxedMorphCollection boxedMorphVector = new BoxedMorphCollection();

    protected final JPanel centrePanel;
    protected String icon;
    protected Point lastMouseDown;
    protected Dim lastMouseDownSize;
    protected Point lastMouseDrag;
    protected Dim lastMouseDragSize;
    protected MorphDrawer morphDrawer;
    protected PropertyChangeSupport pcs = new PropertyChangeSupport(this);
    protected boolean showBoxes = true;


    protected String toolTip;

    public SwingMorphView(AppData appData) {
        this.appData = appData;
        this.setLayout(new BorderLayout());
        this.centrePanel = new JPanel() {

            private static final long serialVersionUID = 1L;

            @Override
            public void paintComponent(Graphics g) {
                paintMorphViewPanel((Graphics2D) g,
                        SwingGeom.toWatchmakerDim(this.getSize()));
            }
        };
        // this.setPreferredSize(new Dimension(640, 480));
        this.setBorder(BorderFactory.createLineBorder(Color.black));
        this.add(centrePanel, BorderLayout.CENTER);
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
        centrePanel.addMouseListener(mouseAdapter);
        centrePanel.addMouseMotionListener(mouseAdapter);
        PhenotypeDrawer phenotypeDrawer = appData.getPhenotypeDrawer();
        morphDrawer = new SwingMorphDrawer(phenotypeDrawer);
        phenotypeDrawer.getDrawingPreferences().addPropertyChangeListener(this);

        SwingScaleSlider scaleSlider = new SwingScaleSlider(
                appData.getPhenotypeDrawer().getDrawingPreferences());

        this.add((JSlider) scaleSlider.getPanel(), BorderLayout.PAGE_END);
    }

    public SwingMorphView(AppData appData, String icon, String name) {
        this(appData);
        this.setIcon(icon);
        this.setName(name);

    }

    public SwingMorphView(AppData appData, String icon, String name,
            boolean engineeringMode, boolean geneBoxToSide) {
        this(appData, icon, name);
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
    public BoxedMorphCollection getBoxedMorphVector() {
        return boxedMorphVector;
    }

    @Override
    public JPanel getCentrePanel() {
        return centrePanel;
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
        return boxedMorphVector.getMorphs();
    }

    @Override
    public String getToolTip() {
        return toolTip;
    }

    @Override
    public boolean isShowBoxes() {
        return showBoxes;
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
        synchronized (boxedMorphVector) {
            BoxManager boxes = boxedMorphVector.getBoxes();
            if (showBoxes) {
                Vector<Integer> backgroundColors = new Vector<Integer>();
                Vector<BoxedMorph> boxedMorphs = boxedMorphVector.getBoxedMorphs();
                for (int i = 0; i < boxes.getBoxCount(); i++) {
                    BoxedMorph boxedMorph = boxedMorphVector.getBoxedMorph(boxes.getBox(i));
                    if (boxedMorph != null) {
                        backgroundColors.add(boxedMorph.getMorph()
                                .getPhenotype().getBackgroundColor());
                    } else {
                        backgroundColors.add(-1);
                    }
                }

                BoxesDrawer boxesDrawer = appData.getBoxesDrawer();
                boolean midBoxOnly = boxedMorphVector.getBoxedMorphs()
                        .size() == 1;
                boxesDrawer.draw(graphicsContext, size, boxes, midBoxOnly,
                        backgroundColors);
            }
            int counter = 0;
            Iterator<BoxedMorph> iter = boxedMorphVector.iterator();
            logger.fine("Boxed morphs to paint: "
                    + boxedMorphVector.getBoxedMorphs().size());
            while (iter.hasNext()) {
                logger.fine(
                        "SwingMorphView.paintMorphViewPanel() Getting BoxedMorph "
                                + counter);
                BoxedMorph boxedMorph = iter.next();
                morphDrawer.draw(boxedMorph, graphicsContext, size,
                        boxedMorph == this.boxedMorphVector
                                .getSelectedBoxedMorph());
                counter++;
            }
        }
    }

    protected void processMouseMotion(Point myPt, Dim size) {}

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
    public void setBoxedMorphVector(BoxedMorphCollection boxedMorphVector) {
        this.boxedMorphVector = boxedMorphVector;
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
        SwingUtilities.convertPointFromScreen(p, centrePanel);
        logger.info("Converted point " + p);
        if (p.x > -1 && p.y > -1) {
            Dim size = SwingGeom.toWatchmakerDim(centrePanel.getSize());
            logger.info("processMouseMotion called");
            processMouseMotion(SwingGeom.toWatchmakerPoint(p), size);
            logger.info("processMouseMotion returned");
        }

    }

}
