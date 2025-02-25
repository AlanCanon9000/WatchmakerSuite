package net.richarddawkins.watchmaker.morphs.mono.genome;

import java.nio.ByteBuffer;

import net.richarddawkins.watchmaker.genome.Gene;
import net.richarddawkins.watchmaker.genome.GeneManipulationEvent;
import net.richarddawkins.watchmaker.genome.Genome;
import net.richarddawkins.watchmaker.genome.GooseDirection;
import net.richarddawkins.watchmaker.genome.IntegerGene;
import net.richarddawkins.watchmaker.morphs.mono.genome.type.SwellType;

public class IntegerGradientGene extends IntegerGene {
	@Override
    public boolean genomicallyEquals(Gene gene) {
        
        if(! (gene instanceof IntegerGradientGene)) return false;
        IntegerGradientGene that = (IntegerGradientGene) gene;
        if(this.gradient != that.getGradient()) return false;
        return super.genomicallyEquals(gene);
    }
    public IntegerGradientGene(Genome genome, String name) {
		super(genome, name);
	}
	@Override
	public String toString() {
		return super.toString() + 
				(gradient == SwellType.Same ? "" : (gradient == SwellType.Shrink ? "-" : "+"));
	}
	@Override
	public void readIndexedValueFromByteBuffer(ByteBuffer byteBuffer, int index) {
		super.readIndexedValueFromByteBuffer(byteBuffer, index);
		if(index == 1) {
			setGradient(SwellType.values()[byteBuffer.get()]);
		}
	}
	@Override
	public void writeIndexedValueToByteBuffer(ByteBuffer byteBuffer, int index) {
		super.writeIndexedValueToByteBuffer(byteBuffer, index);
		if(index == 1) {
			byteBuffer.put((byte) gradient.ordinal());
		}
	}
	protected SwellType gradient = SwellType.Same;

	public SwellType getGradient() {
		return gradient;
	}
	@Override
	public void geneManipulated(GeneManipulationEvent gbme) {
		super.geneManipulated(gbme);
		GooseDirection direction = gbme.getGooseDirection();
		switch(direction) {
		case upArrow:
			setGradient(SwellType.Swell);
			break;
		case equalsSign:
			setGradient(SwellType.Same);
			break;
		case downArrow:
			setGradient(SwellType.Shrink);
			break;
		default:
		}
	}
	public void setGradient(SwellType newValue) {
		SwellType oldValue = this.gradient;
		this.gradient = newValue;
		pcs.firePropertyChange("gradient", oldValue, newValue);
	}
	@Override
	public void copy(Gene destinationGene) {
		super.copy((IntegerGene) destinationGene);
		((IntegerGradientGene)destinationGene).setGradient(gradient);
	} 
}
