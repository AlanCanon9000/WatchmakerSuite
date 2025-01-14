package net.richarddawkins.watchmaker.swing.app;

import java.awt.Component;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.io.File;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;
import java.util.logging.Logger;

import javax.swing.JFileChooser;

import net.richarddawkins.watchmaker.album.Album;
import net.richarddawkins.watchmaker.album.AlbumSerializer;
import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.component.WatchPanel;
import net.richarddawkins.watchmaker.cursor.WatchmakerCursor;
import net.richarddawkins.watchmaker.cursor.WatchmakerCursorFactory;
import net.richarddawkins.watchmaker.genome.Genome;
import net.richarddawkins.watchmaker.geom.BoxManager;
import net.richarddawkins.watchmaker.geom.BoxedMorph;
import net.richarddawkins.watchmaker.geom.BoxesDrawer;
import net.richarddawkins.watchmaker.geom.GeometryManager;
import net.richarddawkins.watchmaker.geom.GridBoxManager;
import net.richarddawkins.watchmaker.geom.Rect;
import net.richarddawkins.watchmaker.image.ClassicImageLoader;
import net.richarddawkins.watchmaker.image.ClassicImageLoaderService;
import net.richarddawkins.watchmaker.menu.MenuBuilder;
import net.richarddawkins.watchmaker.menu.WatchmakerCheckBoxMenuItem;
import net.richarddawkins.watchmaker.menu.WatchmakerMenuBar;
import net.richarddawkins.watchmaker.menu.WatchmakerMenuBuilderService;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.MorphConfig;
import net.richarddawkins.watchmaker.morph.draw.BoxedMorphCollection;
import net.richarddawkins.watchmaker.morph.draw.MorphDrawer;
import net.richarddawkins.watchmaker.morphview.MorphView;
import net.richarddawkins.watchmaker.morphview.MorphViewFactory;
import net.richarddawkins.watchmaker.morphview.MorphViewFactoryService;
import net.richarddawkins.watchmaker.morphview.MorphViewType;
import net.richarddawkins.watchmaker.morphview.MorphViewsTabbedPanel;
import net.richarddawkins.watchmaker.phenotype.PhenotypeDrawer;
import net.richarddawkins.watchmaker.swing.AWTGeometryManager;
import net.richarddawkins.watchmaker.swing.album.SwingAlbumMorphView;
import net.richarddawkins.watchmaker.swing.breed.SwingBreedingMorphView;
import net.richarddawkins.watchmaker.swing.breed.SwingBreedingMorphViewPanel;
import net.richarddawkins.watchmaker.swing.components.SwingWatchPanel;
import net.richarddawkins.watchmaker.swing.cursor.SwingWatchmakerCursorFactory;
import net.richarddawkins.watchmaker.swing.drawer.SwingBoxesDrawer;
import net.richarddawkins.watchmaker.swing.drawer.SwingMorphDrawer;
import net.richarddawkins.watchmaker.swing.menu.SwingWatchmakerMenuBar;

public abstract class SwingAppData implements AppData {

    public SwingAppData() {
        this.geometryManager = new AWTGeometryManager();
        this.watchmakerCursorFactory = new SwingWatchmakerCursorFactory();
        this.classicImageLoader = ClassicImageLoaderService.getInstance()
                .getClassicImageLoader();
        this.morphViewFactory = MorphViewFactoryService.getInstance()
                .getFactory();
    }

    public MorphDrawer newMorphDrawer() {
        return new SwingMorphDrawer(this);
    }

    @Override
    public WatchPanel newWatchPanel() {
        return new SwingWatchPanel();
    }

    protected ClassicImageLoader classicImageLoader;

    @Override
    public ClassicImageLoader getClassicImageLoader() {
        return classicImageLoader;
    }

    class WatchmakerTask extends TimerTask {

        protected AppData appData;

        public WatchmakerTask(AppData appData) {
            this.appData = appData;
        }

        @Override
        public void run() {
            appData.actionBreedFromSelector();
        }
    }

    private static Logger logger = Logger
            .getLogger("net.richarddawkins.watchmaker.swing.app.SwingAppData");
    protected BoxesDrawer boxesDrawer = new SwingBoxesDrawer();
    protected boolean breedRightAway = true;

    protected MorphConfig config;;

    Album currentAlbum = null;

    protected int defaultBreedingCols = 5;

    protected int defaultBreedingRows = 3;

    JFileChooser fileChooser = new JFileChooser();

    protected boolean geneBoxToSide;

    protected GeometryManager geometryManager;

    @Override
    public GeometryManager getGeometryManager() {
        return geometryManager;
    }

    @Override
    public void setGeometryManager(GeometryManager geometryManager) {
        this.geometryManager = geometryManager;
    }

    protected boolean highlighting = false;

    protected String icon;

    protected MenuBuilder menuBuilder;

    protected MorphViewsTabbedPanel morphViewsTabbedPane;

    protected String name;

    protected final PropertyChangeSupport pcs = new PropertyChangeSupport(this);

    protected PhenotypeDrawer phenotypeDrawer;

    protected boolean saltOnEmptyBreedingBoxClick = false;

    protected boolean showBoundingBox = true;

    protected WatchmakerTask task = null;

    protected long tickDelay = 4;

    protected String toolTip;

    protected WatchmakerCursorFactory watchmakerCursorFactory;

    @Override
    public WatchmakerCursorFactory getWatchmakerCursorFactory() {
        return watchmakerCursorFactory;
    }

    @Override
    public void setWatchmakerCursorFactory(
            WatchmakerCursorFactory watchmakerCursorFactory) {
        this.watchmakerCursorFactory = watchmakerCursorFactory;
    }

    public void actionBreedFromSelector() {
        // Find the topmost breeding panel and breed from it.
        SwingBreedingMorphView morphView = (SwingBreedingMorphView) this
                .getBreedingMorphViews().elementAt(0);
        morphView.breedFromSelector();
    }

    protected MorphViewFactory morphViewFactory;

    @Override
    public void addAlbumMorphView(Album album) {
        MorphView newAlbumMorphView = morphViewFactory.getMorphView(this,
                "Album", null, album);

        morphViewsTabbedPane.addMorphView(newAlbumMorphView);
    }

    @Override
    public void addBreedingMorphView(Morph morph) {
        Vector<Morph> seedMorphs = new Vector<Morph>();
        if (morph != null) {
            Morph copy = config.newMorph();
            Genome genome = config.newGenome();
            morph.getGenome().copy(genome);
            copy.setGenome(genome);
            seedMorphs.add(copy);
        } else {
            logger.fine("addBreedingMorphView Seeding basic type");
            seedMorphs.addElement(
                    config.newMorph(config.getStartingMorphBasicType()));
        }
        SwingBreedingMorphView morphView = (SwingBreedingMorphView) morphViewFactory
                .getMorphView(this, MorphViewType.breeding.getName(),
                        seedMorphs, null);
        morphViewsTabbedPane.addMorphView(morphView);

        if (isBreedRightAway()) {
            SwingBreedingMorphViewPanel panel = (SwingBreedingMorphViewPanel) morphView
                    .getPanels().firstElement();

            panel.setBreedFromMidBoxOnNextRepaint(true);

        }

    }

    @Override
    public void addClassicAlbum(String albumName) {
        Collection<Album> albums = config.getAlbums();
        if (albums != null) {
            for (Album album : albums) {
                if (album.getName().equals(albumName)) {
                    addAlbumMorphView(album);
                }
            }
        }
    }

    @Override
    public void addClassicAlbums() {
        Collection<Album> albums = config.getAlbums();
        if (albums != null) {
            for (Album album : albums) {
                addAlbumMorphView(album);
            }
        }
    }

    @Override
    public void addDefaultMorphView() {
        addBreedingMorphView(null);
    }

    @Override
    public void addEngineeringMorphView(Morph morph) {
        Vector<Morph> seedMorphs = new Vector<Morph>();
        seedMorphs.add(morph);
        MorphView morphView = morphViewFactory.getMorphView(this,
                MorphViewType.engineering.getName(), seedMorphs, null);
        morphViewsTabbedPane.addMorphView(morphView);
    }

    @Override
    public void addMorphToAlbum() {
        Morph morph = this.getMorphOfTheHour();
        Vector<MorphView> albumMorphViews = this.getAlbumMorphViews();
        MorphView albumMorphView;
        if (albumMorphViews.isEmpty()) {
            Album album = new Album("Untitled");
            BoxedMorphCollection boxedMorphs = new BoxedMorphCollection();
            BoxManager boxManager = new GridBoxManager(5,3);
            boxedMorphs.setBoxManager(boxManager);
            album.addPage(boxedMorphs);
            Rect rect = boxManager.getBox(boxManager.getBoxCount());
            BoxedMorph boxedMorph = new BoxedMorph(boxManager, morph, rect);
            boxedMorphs.add(boxedMorph);
            this.addAlbumMorphView(album);
        } else {
            albumMorphView = albumMorphViews.firstElement();
            albumMorphView.addSeedMorph(morph);
            albumMorphView.repaint();

        }
    }

    @Override
    public void addPedigreeMorphView() {
        Vector<Morph> seedMorphs = new Vector<Morph>();
        seedMorphs.add(getMorphOfTheHour());
        morphViewsTabbedPane.addMorphView(morphViewFactory.getMorphView(this,
                MorphViewType.pedigree.getName(), seedMorphs, null));

    }

    @Override
    public void addPropertyChangeListener(PropertyChangeListener listener) {
        pcs.addPropertyChangeListener(listener);
    }

    @Override
    public void addPropertyChangeListener(String propertyName,
            PropertyChangeListener listener) {
        pcs.addPropertyChangeListener(propertyName, listener);
    }

    @Override
    public void addTriangleMorphView() {
        Vector<Morph> seedMorphs = new Vector<Morph>();
        seedMorphs.addAll(
                Arrays.asList(this.getMorphConfig().getTriangleMorphs()));
        morphViewsTabbedPane.addMorphView(morphViewFactory.getMorphView(this,
                MorphViewType.triangle.getName(), seedMorphs, null));

    }

    protected boolean recordingFossils;

    @Override
    public boolean isRecordingFossils() {
        return recordingFossils;
    }

    public void setRecordingFossils(boolean recordingFossils) {
        this.recordingFossils = recordingFossils;
    }

    @Override
    public void albumDelete() {
        String fileName = currentAlbum.getFileName();
        if (fileName != null) {
            new File(fileName).delete();
        }
    }

    @Override
    public void albumExport() {

    }

    @Override
    public void albumNew() {
        currentAlbum = new Album("Untitled");
        this.addAlbumMorphView(currentAlbum);
    }

    @Override
    public void albumOpen() {
        int returnVal = fileChooser.showOpenDialog(
                (Component) this.getMorphViewsTabbedPane().getComponent());

        if (returnVal == JFileChooser.APPROVE_OPTION) {
            File file = fileChooser.getSelectedFile();
            // This is where a real application would open the file.
            logger.info("Opening: " + file.getName() + ".");
        } else {
            logger.info("Open command cancelled by user.");
        }
    }

    @Override
    public void albumSave() {
        if (currentAlbum.isDirty()) {
            if (currentAlbum.getFileName() == null) {
                albumSaveAs();
            } else {
                new AlbumSerializer(config).putAlbumToFile(currentAlbum,
                        new File(currentAlbum.getFileName()));
            }

        }
    }

    @Override
    public void albumSaveAs() {
        if (currentAlbum.isDirty()) {
            int returnVal = fileChooser
                    .showSaveDialog((Component) this.getMorphViewsTabbedPane());

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = fileChooser.getSelectedFile();
                new AlbumSerializer(config).putAlbumToFile(currentAlbum, file);
                logger.info("Saving: " + file.getName() + ".");
            } else {
                logger.info("Save command cancelled by user.");
            }
        }
    }

    @Override
    public Vector<MorphView> getAlbumMorphViews() {
        Vector<MorphView> morphViews = new Vector<MorphView>();
        for (MorphView morphView : getMorphViewsTabbedPane().getMorphViews()) {
            if (morphView instanceof SwingAlbumMorphView) {
                morphViews.add(morphView);
            }
        }
        Collections.reverse(morphViews);
        return morphViews;
    }

    @Override
    public BoxesDrawer getBoxesDrawer() {
        return boxesDrawer;
    }

    @Override
    public Vector<MorphView> getBreedingMorphViews() {
        Vector<MorphView> morphViews = new Vector<MorphView>();
        for (MorphView morphView : getMorphViewsTabbedPane().getMorphViews()) {
            if (morphView instanceof SwingBreedingMorphView) {
                morphViews.add(morphView);
            }
        }
        Collections.reverse(morphViews);
        return morphViews;
    }

    public Album getCurrentAlbum() {
        return currentAlbum;
    }

    @Override
    public int getDefaultBreedingCols() {
        return defaultBreedingCols;
    }

    @Override
    public int getDefaultBreedingRows() {
        return defaultBreedingRows;
    }

    @Override
    public String getIcon() {
        return icon;
    }

    @Override
    public MenuBuilder getMenuBuilder() {
        return menuBuilder;
    }

    @Override
    public MorphConfig getMorphConfig() {
        return config;
    }

    @Override
    public Morph getMorphOfTheHour() {
        MorphView morphView = getSelectedMorphView();
        if (morphView != null) {
            Morph morphOfTheHour = morphView.getMorphOfTheHour();
            logger.info("getMorphOfTheHour" + morphOfTheHour);
            return morphView.getMorphOfTheHour();
        } else {
            return null;
        }
    }

    protected MorphView selectedMorphView;

    @Override
    public MorphView getSelectedMorphView() {
        logger.info("getSelectedMorphView: " + selectedMorphView);
        return selectedMorphView;
    }

    @Override
    public void setSelectedMorphView(MorphView newValue) {
        if (selectedMorphView != null) {
            selectedMorphView.cleanMenu(SwingWatchmakerMenuBar.getInstance());
        }
        logger.info("setSelectedMorphView: " + newValue);
        selectedMorphView = newValue;
        rebuildMenuBar();

    }

    @Override
    public void updateMenuBar() {
        WatchmakerMenuBar menuBar = SwingWatchmakerMenuBar.getInstance();
        MenuBuilder watchmakerMenuBuilder = WatchmakerMenuBuilderService
                .getInstance().getWatchmakerMenuBuilder();

        watchmakerMenuBuilder.updateMenu(menuBar);
        MenuBuilder speciesSpecificMenuBuilder = this.getMenuBuilder();
        speciesSpecificMenuBuilder.updateMenu(menuBar);
        // Let the available morph view modules have a crack at installing their
        // own
        // Menu items.
        MorphViewFactory morphViewFactory = MorphViewFactoryService
                .getInstance().getFactory();
        for (String morphViewType : morphViewFactory.getMorphViewTypes()) {
            morphViewFactory.getMenuBuilder(morphViewType).updateMenu(menuBar);
        }

        selectedMorphView.updateMenu(menuBar);

        WatchmakerCursorFactory cursors = this.getWatchmakerCursorFactory();
        WatchmakerCheckBoxMenuItem highlightBiomorph = (WatchmakerCheckBoxMenuItem) menuBar
                .getMenu("Edit").getMenu("Highlight biomorph");
        if (highlightBiomorph != null) {
            boolean isHighlight = cursors.isCursorType(
                    WatchmakerCursor.highlight,
                    this.getSelectedMorphView().getSelectedPanel().getCursor());
            highlightBiomorph.setSelected(isHighlight);
        }
        menuBar.repaint();
    }

    @Override
    public void rebuildMenuBar() {
        WatchmakerMenuBar menuBar = SwingWatchmakerMenuBar.getInstance();
        WatchmakerMenuBuilderService.getInstance().getWatchmakerMenuBuilder()
                .buildMenu(menuBar);
        MenuBuilder speciesSpecificMenuBuilder = this.getMenuBuilder();
        speciesSpecificMenuBuilder.buildMenu(menuBar);
        // Let the available morph view modules have a crack at installing their
        // own
        // Menu items.
        MorphViewFactory morphViewFactory = MorphViewFactoryService
                .getInstance().getFactory();
        for (String morphViewType : morphViewFactory.getMorphViewTypes()) {
            morphViewFactory.getMenuBuilder(morphViewType).buildMenu(menuBar);
        }

        selectedMorphView.buildMenu(menuBar);

        updateMenuBar();
        menuBar.repaint();
    }

    @Override
    public MorphViewsTabbedPanel getMorphViewsTabbedPane() {
        return this.morphViewsTabbedPane;
    }

    public MorphView getMostRecentWritableAlbumMorphView() {
        for (MorphView morphView : getAlbumMorphViews()) {
            if (morphView.getAlbum().isWritable()) {
                return morphView;
            }
        }
        return null;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public PhenotypeDrawer getPhenotypeDrawer() {
        return phenotypeDrawer;
    }

    @Override
    public long getTickDelay() {
        return tickDelay;
    }

    @Override
    public String getToolTip() {
        return toolTip;
    }

    public boolean isBreedRightAway() {
        return breedRightAway;
    }

    public boolean isGeneBoxToSide() {
        return geneBoxToSide;
    }

    public boolean isHighlighting() {
        return highlighting;
    }

    public boolean isSaltOnEmptyBreedingBoxClick() {
        return saltOnEmptyBreedingBoxClick;
    }

    @Override
    public boolean isShowBoundingBox() {
        return showBoundingBox;
    }

    @Override
    public void newRandomStart() {

        Morph morph = getMorphOfTheHour();
        Genome genome = config.getGenomeFactory().deliverSaltation();
        morph.setGenome(genome);
        MorphView morphView = this.getSelectedMorphView();
        morphView.addSeedMorph(morph);
    }

    public void setBreedRightAway(boolean breedRightAway) {
        this.breedRightAway = breedRightAway;
    }

    public void setCurrentAlbum(Album currentAlbum) {
        this.currentAlbum = currentAlbum;
    }

    @Override
    public void setDefaultBreedingCols(int defaultBreedingCols) {
        this.defaultBreedingCols = defaultBreedingCols;
    }

    @Override
    public void setDefaultBreedingRows(int defaultBreedingRows) {
        this.defaultBreedingRows = defaultBreedingRows;
    }

    public void setGeneBoxToSide(boolean geneBoxToSide) {
        this.geneBoxToSide = geneBoxToSide;
    }

    public void setHighlighting(boolean newValue) {
        boolean oldValue = highlighting;
        highlighting = newValue;
        pcs.firePropertyChange("highlighting", oldValue, newValue);
    }

    @Override
    public void setIcon(String icon) {
        this.icon = icon;
    }

    @Override
    public void setMenuBuilder(MenuBuilder menuBuilder) {
        this.menuBuilder = menuBuilder;
    }

    @Override
    public void setMorphConfig(MorphConfig config) {
        this.config = config;
        config.setAppData(this);

    }

    @Override
    public void setMorphViewsTabbedPane(
            MorphViewsTabbedPanel morphViewsTabbedPane) {
        this.morphViewsTabbedPane = morphViewsTabbedPane;

    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public void setPhenotypeDrawer(PhenotypeDrawer newValue) {
        this.phenotypeDrawer = newValue;
    }

    public void setSaltOnEmptyBreedingBoxClick(
            boolean saltOnEmptyBreedingBoxClick) {
        this.saltOnEmptyBreedingBoxClick = saltOnEmptyBreedingBoxClick;
    }

    @Override
    public void setShowBoundingBox(boolean newValue) {
        boolean oldValue = this.showBoundingBox;
        this.showBoundingBox = newValue;
        pcs.firePropertyChange("showBoundingBox", oldValue, newValue);
    }

    @Override
    public void setTickDelay(long tickDelay) {
        this.tickDelay = tickDelay;
    }

    @Override
    public void setToolTip(String toolTip) {
        this.toolTip = toolTip;
    }

    @Override
    public synchronized void startTimedBreed() {
        if (task == null) {
            task = new WatchmakerTask(this);
            Timer timer = new Timer();
            int seconds = 5;
            timer.schedule(task, 0, seconds * 1000);
        }
    }

    @Override
    public void stopTimedBreed() {
        if (task != null) {
            task.cancel();
            task = null;
        }
    }

    public String toString() {
        StringBuffer buffer = new StringBuffer();
        buffer.append(name);
        if (breedRightAway)
            buffer.append(" breedRightAway");
        if (saltOnEmptyBreedingBoxClick)
            buffer.append(" saltOnEmptyBreedingBoxClick");
        if (geneBoxToSide)
            buffer.append(" geneBoxToSide");
        if (highlighting)
            buffer.append(" highlighting");
        buffer.append(" " + defaultBreedingCols + "x" + defaultBreedingRows);
        return buffer.toString();
    }
}
