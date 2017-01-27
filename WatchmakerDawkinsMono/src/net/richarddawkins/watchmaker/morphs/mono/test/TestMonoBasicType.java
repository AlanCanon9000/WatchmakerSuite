package net.richarddawkins.watchmaker.morphs.mono.test;

import net.richarddawkins.watchmaker.geom.Rect;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.MorphConfig;
import net.richarddawkins.watchmaker.morphs.bio.geom.Lin;
import net.richarddawkins.watchmaker.morphs.bio.geom.Pic;
import net.richarddawkins.watchmaker.morphs.mono.MonochromeMorphConfig;
import net.richarddawkins.watchmaker.morphs.mono.geom.MonoLin;
import net.richarddawkins.watchmaker.phenotype.Phenotype;

public class TestMonoBasicType {

	/**
	 * Test harness for Monochrome biomorphs.
	 * 
	 * Creates a minimal monochrome biomorph, retrieves its Phenotype (body),
	 * then prints its list of Lins to the console, together with a
	 * a summary of the phenotype's characteristics. 
	 * @author Alan Canon
	 * @param args ignored.
	 */
	public static void main(String[] args) {
		
		// Get a new MonochromeMorphConfig.
		MorphConfig config = new MonochromeMorphConfig();
		
		// Get the MorphConfig to cough up a minimal biomorph.
		Morph morph = config.newMorph(0);
		
		// Obtain a reference to the morph's body, a collection
		// of drawing primitives and a calculated "margin",
		// which is the bounding rectangle of the morph's body.
		Phenotype phenotype = morph.getPic();
		
		// Iterate through the list of lines. We cast the phenotype
		// to its Pic subclass first, since Phenotype is more general and
		// one could conceive of designing a biomorph type that has some
		// other way of representing its body than a list of drawing primitives.
		for(Lin lin: ((Pic) phenotype).lines) {

			// We know this is a Monochrome Biomorph so it's safe to cast its
			// Lin instances to instances of the MonoLin subclass of Lin. 
			// If you tried to do this to a ColourLin, you'd get a ClassCastException
			// at runtime.
			MonoLin monoLin = (MonoLin) lin;
			
			// Print out a string representation of the Lin.
			System.out.println(monoLin.toString());
		}
		// How many Lins are in the morph's phenotype? Print it out.
		System.out.println("Morph has " + phenotype.size() + " elements.");
		
		// Get a reference to the bounding rectangle of the morph.
		Rect margin = phenotype.getMargin();
		/*
		 Print out the upper left hand vertex of the rectangle, and its
		 midpoint (Knowing the midpoint is useful for ensuring that the biomorph
		 is drawn at the center of the display area, by calculating the
		 difference between the midpoint of the biomorph and the midpoint of
		 whatever rectangle on the display is going to have the biomorph drawn in it.
		 For example, say the midpoint (Bx, By) of the biomorph is (0, -19) (which
		 it is, in this example) Say you have a display area 100 pixels on a side, so the
		 midpoint (Dx, Dy) is at (50, 50). Then, to move the biomorph so its own
		 midpoint is at the center of the display, you would need to calculate B - D = 
		 (50, 50) - (0, -19) = (50 - 0, 50 - [-19]) = (50, 69). So before plotting each
		 point of the biomorph, it's then necessary to add 50 to the X coordinate and
		 69 to the Y coordinate. If I haven't got my math wrong.
		 */
		System.out.println("Bounding Rectangle: " + margin + " with midpoint " + margin.getMidPoint());
		
	}
}