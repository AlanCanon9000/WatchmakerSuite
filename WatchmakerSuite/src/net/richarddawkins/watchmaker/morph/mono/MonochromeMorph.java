package net.richarddawkins.watchmaker.morph.mono;


import java.awt.Rectangle;

import net.richarddawkins.watchmaker.genome.Genome;
import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.MorphConfig;
import net.richarddawkins.watchmaker.morph.SimpleMorph;
import net.richarddawkins.watchmaker.morph.biomorph.geom.Point;
import net.richarddawkins.watchmaker.morph.mono.genome.MonochromeGenome;
/**
 * MonochromeBiomorph is a subinterface of Morph which represents Monochrome Biomorphs.
 * <h2>Original source code from Monochrome Biomorphs/Biomorphs</h2>
 * <pre>
 * TYPE
 *   SwellType = (Swell, Same, Shrink); 
 *   CompletenessType = (Single, Double);
 *   SpokesType = (NorthOnly, NSouth, Radial); 
 *   chromosome = ARRAY[1..9] OF Integer; 
 *   
 *   person = RECORD 
 *     gene: chromosome; 
 *     dgene: ARRAY[1..10] OF SwellType;
 *     SegNoGene: Integer; 
 *     SegDistGene: Integer; 
 *     CompletenessGene: CompletenessType;
 *     SpokesGene: SpokesType; 
 *     tricklegene, mutsizegene, mutprobgene: Integer;
 *   end;
 * 
 *   FullPtr = ^Full; 
 *   FullHandle = ^FullPtr; 
 *   
 *   Full = RECORD 
 *     genome: person;
 *     surround: Rect; 
 *     origin, centre: Point; 
 *     parent: FullHandle; 
 *     firstborn: FullHandle; 
 *     lastborn: FullHandle; 
 *     eldersib: FullHandle; 
 *     youngersib: FullHandle; 
 *     Prec, Next: FullHandle; 
 *     Damaged{,Blackened} : Boolean;
 *     snapHandle: Handle; 
 *     snapBytes: Integer; 
 *     snapBounds: Rect; 
 *   end;
 * </pre>
 * @author alan
 *
 */
public class MonochromeMorph extends SimpleMorph {
	
	protected MonochromeMorphConfig config;
	@Override
	public void setMorphConfig(MorphConfig config) {
		this.config = (MonochromeMorphConfig) config;
	}
	@Override
	public MorphConfig getMorphConfig() {
		return config;
	}
	@Override
	public Genome getGenome() {
		return genome;
	}
	@Override
	public void setGenome(Genome genome) {
		this.genome = (Genome) genome;
	}
	MonochromeMorph() {
		setGenome(new MonochromeGenome(this));
	}
	MonochromeMorph(MorphConfig config) {
		this();
		setMorphConfig(config);
	}

	MonochromeMorph(MorphConfig config, int basicType) {
		this(config);
		genome.setBasicType(basicType);
	}

	public Morph reproduce() {
		MonochromeMorph child = new MonochromeMorph(config);
		child.setGenome((Genome) genome.reproduce((Morph) child));
		child.getPedigree().parent = this;
		return child;
	}
	
	protected Rectangle surround;
	protected Point origin;
	protected Point centre;

	protected boolean damaged; // ,Blackened
	protected Object snapHandle;
	protected int snapBytes;
	protected Rectangle snapBounds;



}
