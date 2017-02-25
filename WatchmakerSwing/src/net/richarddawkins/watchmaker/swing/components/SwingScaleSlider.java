package net.richarddawkins.watchmaker.swing.components;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.util.logging.Logger;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import net.richarddawkins.watchmaker.morphview.MorphViewWidget;
import net.richarddawkins.watchmaker.phenotype.DrawingPreferences;

public class SwingScaleSlider implements MorphViewWidget, ChangeListener {
	private static Logger logger = Logger.getLogger("net.richarddawkins.watchmaker.swing.components.SwingScaleSlider");

	
	private static final long serialVersionUID = 1L;
	static final int SCALE_MIN = -8;
	static final int SCALE_MAX = +8;
	static final int SCALE_INIT = 0; // initial frames per second
	protected DrawingPreferences drawingPreferences;
	public SwingScaleSlider(DrawingPreferences drawingPreferences) {
        this.drawingPreferences = drawingPreferences;
        this.panel = new JPanel();
        panel.setLayout(new GridBagLayout());
	    GridBagConstraints constraints = new GridBagConstraints();
	    constraints.gridx = 0;
	    constraints.gridy = 0;
	    JLabel label = new JLabel("Scale (2^n)");
	    panel.add(label, constraints);
	    constraints.gridy = 1;
        
		JSlider slider = new JSlider(JSlider.HORIZONTAL, SCALE_MIN, SCALE_MAX, SCALE_INIT);
		slider.addChangeListener(this);
		// Turn on labels at major tick marks.
		slider.setMajorTickSpacing(1);
		slider.setPaintTicks(true);
		slider.setPaintLabels(true);
		panel.add(slider,constraints);
	}
	
	@Override
	public void stateChanged(ChangeEvent e) {
	    JSlider slider = (JSlider) e.getSource();
		if(! slider.getValueIsAdjusting()) {
			int scale = slider.getValue();
			logger.info("New scale slider value: " + scale);
			drawingPreferences.setScale(scale);
		}
	}

	protected JPanel panel;
	
	@Override
	public JPanel getPanel() {
		return panel;
	}

    @Override
    public void setPanel(Object newValue) {
        panel = (JPanel) newValue;
        
    }

}
