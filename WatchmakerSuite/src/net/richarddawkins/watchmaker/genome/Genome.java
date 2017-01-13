package net.richarddawkins.watchmaker.genome;

import java.awt.Dimension;
import java.awt.Graphics2D;
import java.beans.PropertyChangeListener;

import net.richarddawkins.watchmaker.morph.Morph;

public interface Genome extends PropertyChangeListener {
	Morph getMorph();
	Genome reproduce(Morph morph);
	void setBasicType(int i);
	void setMorph(Morph simpleMorphImpl);
	
	/**
	 * Attempt to mutate the genome represented by this Person.
	 * @param g2 the Graphics2D context upon which drawing is to take place
	 * @param d the dimension of the box within which drawing is to take place
	 * @param zeroMargin whether to zero the margins of the bounding box.
	 */

	void develop(Graphics2D g2, Dimension d, boolean zeroMargin);
	Gene[] toGeneArray();
	Gene getGene(int geneBoxIndex);
	void addPropertyChangeListener(PropertyChangeListener listener);
	void removePropertyChangeListener(PropertyChangeListener listener);
	
	void copy(Genome genome);
	
}
