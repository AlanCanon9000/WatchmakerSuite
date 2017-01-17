package net.richarddawkins.watchmaker.morphs.mono;

import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.MorphType;
import net.richarddawkins.watchmaker.morph.Mutagen;
import net.richarddawkins.watchmaker.morphs.bio.BiomorphConfig;
import net.richarddawkins.watchmaker.morphs.mono.genome.MonochromeMutagen;

public class MonochromeMorphConfig extends BiomorphConfig {

	public static final int MutTypeNo = 9;


	protected MonochromeMutagen mutagen;

	

	public Mutagen getMutagen() {
		return mutagen;
	}

	public MonochromeMorphConfig() {
		super(MorphType.MONOCHROME_BIOMORPH);
		geneBoxCount = 16;
		
		mut = new boolean[MutTypeNo];
		for (int i = 0; i < MutTypeNo; i++)
			mut[i] = true;

		setDefaultBreedingRows(3);
		setDefaultBreedingCols(5);
        mutagen = new MonochromeMutagen(this);
		
	}

	@Override
	public Morph createMorph(int type) {
		return (Morph) new MonochromeMorph(this, type);
	}


	@Override
	public void setMutagen(Mutagen mutagen) {
		this.mutagen = (MonochromeMutagen) mutagen;

	}
	

	
	



}