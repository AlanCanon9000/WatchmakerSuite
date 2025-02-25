package net.richarddawkins.watchmaker.morphs.colour.genome.swing;

import java.beans.PropertyChangeEvent;

import net.richarddawkins.watchmaker.app.AppData;
import net.richarddawkins.watchmaker.genome.Gene;
import net.richarddawkins.watchmaker.morphs.colour.genome.LimbFillGene;
import net.richarddawkins.watchmaker.morphs.colour.genome.type.LimbFillType;
import net.richarddawkins.watchmaker.swing.genebox.GeneBoxType;
import net.richarddawkins.watchmaker.swing.genebox.SwingTextGeneBox;

public class SwingLimbFillGeneBox extends SwingTextGeneBox {

    /**
     * 
     */
    private static final long serialVersionUID = -8437789443068797495L;

    public SwingLimbFillGeneBox(AppData appData) {
        super(appData);
    }

    public void setLimbFillType(LimbFillType limbFillType) {

        String limbFillName;

        // TODO Add strings for internationalization;
        switch (limbFillType) {
        case Filled:
            limbFillName = limbFillType.toString();
            break;
        case Open:
            limbFillName = limbFillType.toString();
            break;
        default:
            limbFillName = "Unknown";
            // Can't happen;
        }
        valueLabel.setText(limbFillName);
        repaint();
    }

    @Override
    public void setGene(Gene gene) {
        super.setGene(gene);
        setLimbFillType(((LimbFillGene) gene).getValue());
    }

    @Override
    public void propertyChange(PropertyChangeEvent evt) {
        setLimbFillType((LimbFillType) evt.getNewValue());
    }

    @Override
    public void setEngineeringMode() {
        super.setEngineeringMode(GeneBoxType.leftRightOnly);

    }

}
