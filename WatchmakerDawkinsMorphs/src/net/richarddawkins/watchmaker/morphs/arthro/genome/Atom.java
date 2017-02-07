package net.richarddawkins.watchmaker.morphs.arthro.genome;

import java.util.Vector;
import java.util.logging.Logger;

import net.richarddawkins.watchmaker.genome.GeneManipulationEvent;
import net.richarddawkins.watchmaker.genome.SimpleGene;
import net.richarddawkins.watchmaker.morphs.arthro.genome.type.AtomKind;

public class Atom extends SimpleGene {
	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger("net.richarddawkins.watchmaker.morphs.arthro.phenotype.ArthroLin");

	static int[] paramOffset = new int[AtomKind.values().length];

	static {
		// where in a CumParams the Width of an AnimalTrunk gets multiplied in
		paramOffset[AtomKind.AnimalTrunk.ordinal()] = 0;
		paramOffset[AtomKind.AnimalJoint.ordinal()] = 3;
		paramOffset[AtomKind.AnimalClaw.ordinal()] = 6;
		paramOffset[AtomKind.SectionTrunk.ordinal()] = 0;
		paramOffset[AtomKind.SectionJoint.ordinal()] = 3;
		paramOffset[AtomKind.SectionClaw.ordinal()] = 6;
		paramOffset[AtomKind.SegmentTrunk.ordinal()] = 0;
		paramOffset[AtomKind.SegmentJoint.ordinal()] = 3;
		paramOffset[AtomKind.SegmentClaw.ordinal()] = 6;
		paramOffset[AtomKind.Joint.ordinal()] = 3;
		paramOffset[AtomKind.Claw.ordinal()] = 6;

	}

	/**
	 * Original documentation:
	 * <ul>
	 * <li>also used in an AnimalTrunk to store the number of atoms in the
	 * animal.</li>
	 * <li>also used in SectionTrunk to store the Overlap of segments</li>
	 * <li>also used in SegmentTrunk to store the rank number of the
	 * segment</li>
	 * </ul>
	 */
	public double angle;

	/**
	 * Original documentation: where to look in the BoneYard for the next atom.
	 * 0 means end of chain
	 */
	public Atom firstBelowMe;

	public int gradientGene = 0;

	/**
	 * Original documentation: Also used for Thickness of a Joint
	 */
	public double height;

	public AtomKind kind = AtomKind.Free;

	/**
	 * Original documentation: Where to look in the BoneYard for the next atom.
	 * 0 means end of chain. Also used in AnimalTrunk to store Gradient gene,
	 * slightly more or less than 100. Treat as Percentage
	 */
	public Atom nextLikeMe;
	
	public int segmentNumber = 0;

	/**
	 * Original documentation: Also used for Length of a Joint
	 */
	public double width;

	public Atom(AtomKind kind, ArthromorphGenome genome) {
		super(genome, kind.toString());
		this.kind = kind;
		height = 1.0;
		width = 1.0;
		angle = 1.0;
	}

	public Atom(AtomKind kind, double height, double width, double angle, int gradientGene, Atom nextLikeMe, Atom firstBelowMe) {
		super(null, kind.toString());
		this.kind = kind;
		this.height = height;
		this.width = width;
		this.angle = angle;
		this.gradientGene = gradientGene;
		this.nextLikeMe = nextLikeMe;
		this.firstBelowMe = firstBelowMe;
	}

	protected void addChildrenToVectorDepthFirst(Vector<Atom> atoms) {
		atoms.add(this);
		if (this.firstBelowMe != null)
			this.firstBelowMe.addChildrenToVectorDepthFirst(atoms);
		if (this.nextLikeMe != null)
			this.nextLikeMe.addChildrenToVectorDepthFirst(atoms);
	}

	public Atom copy() {
		Atom copy = copyExceptNext();
		if (nextLikeMe != null) {
			copy.nextLikeMe = nextLikeMe.copy();
		}
		return copy;
	}

	public Atom copyExceptNext() {
		Atom copy = new Atom(kind, height, width, angle, gradientGene, null, null);
		copy.setGenome(genome);
		if (firstBelowMe != null) {
			copy.firstBelowMe = firstBelowMe.copy();
		}
		if (nextLikeMe != null) {
			copy.nextLikeMe = nextLikeMe.copy();
		}
		return copy;
	}

	/**
	 * Recursively traverse tree of atoms to calculate the total number of atoms
	 * in the tree.
	 * <h2>Original Pascal Source</h2>
	 * <p>
	 * In Classic Arthromorphs, the NextLikeMe field for AnimalTrunk was used to
	 * store the gradient gene. In the Java version, gradient is separately
	 * tracked in the Arthromorph class. For this reason, the "kind !=
	 * AnimalTrunk" check is not needed.
	 * </p>
	 * 
	 * <pre>
	 * 	function CountAtoms (which: integer): integer;
	 * 	{travel over the Animal, counting Atoms}
	 * 		var
	 * 			count: integer;
	 * 	begin
	 * 		count := 1;	{count me}
	 * 		with BoneYard[which]^^ do
	 * 			begin
	 * 				if FirstBelowMe &lt;&gt; 0 then
	 * 					count := count + CountAtoms(FirstBelowMe);
	 * 				if (NextLikeMe &lt;&gt; 0) and (kind &lt;&gt; AnimalTrunk) then
	 * 					count := count + CountAtoms(NextLikeMe);
	 * 			end;
	 * 		CountAtoms := count;	{Me and all below me}
	 * 	end;
	 * </pre>
	 * 
	 * @return the number of atoms in the tree.
	 */
	public int countAtoms() {
		return this.toVector().size();
	}

	/**
	 * <h2>Original Documentation</h2>
	 * <p>
	 * Delete a section of the animal somewhere near the atom which.
	 * </p>
	 * <p>
	 * Caller must correct the AtomCount of the whole animal. Return false if
	 * failed
	 * </p>
	 * <p>
	 * Must have a hold on the atom above what we delete. If chosen atom is:
	 * </p>
	 * 
	 * <pre>
	 *AnimalTrunk   delete first Sec
	 *	AnimalJoint   delete first Sec
	 *	AnimalClaw	delete first Sec
	 *		SectionTrunk	delete next Sec
	 *			SectionJoint		delete first Seg
	 *			SectionClaw		delete first Seg
	 *				SegmentTrunk		delete next Seg
	 *					SegmentJoint		delete first Joint
	 *					SegmentClaw		delete first Joint
	 *						Joint				delete next Joint
	 *						Joint				delete next Joint
	 *						Joint				delete Claw
	 *							Claw				fail
	 * </pre>
	 * <p>
	 * Also fail if trying to delete last example of a Kind
	 * 
	 * @return whether the delete succeeded.
	 *         </p>
	 */
	public boolean doDelete() {
		Atom chain = null;
		Atom parent = this;
		boolean doDelete = false; // unless we actually succeed in killing one
		if (parent.kind == AtomKind.AnimalTrunk)
			parent = parent.firstBelowMe; // AnimalJoint
		if (parent.kind == AtomKind.AnimalJoint || parent.kind == AtomKind.SectionJoint
				|| parent.kind == AtomKind.SegmentJoint)

			parent = parent.firstBelowMe; // AnimalClaw is parent
		if (parent != null)
			if (parent.kind == AtomKind.SectionTrunk || parent.kind == AtomKind.SegmentTrunk
					|| parent.kind == AtomKind.Joint)
				// Delete NextLikeMe of parent}
				if (parent.nextLikeMe != null) {
					chain = parent.nextLikeMe.nextLikeMe; // May be null;
					parent.nextLikeMe.nextLikeMe = null; // So Kill won't get
															// the rest of chain
					parent.nextLikeMe.kill(); // won't be killing last one,
												// since parent qualifies as one
					parent.nextLikeMe = chain;
					doDelete = true;
				} else // Try to delete FirstBelow
				if (parent.firstBelowMe != null) { // we know FirstBelow exists
					chain = parent.firstBelowMe.nextLikeMe; // Atom after one we
															// will delete
					parent.firstBelowMe.nextLikeMe = null;
					if (chain != null) { // FirstBelow is not only one
						parent.firstBelowMe.kill();
						parent.firstBelowMe = chain;
						doDelete = true;
					}
				}
		return doDelete;
	}

	@Override
	public void geneManipulated(GeneManipulationEvent gbme) {
		// TODO Auto-generated method stub

	}

	public double getAngle() {
		return angle;
	}

	public Atom getFirstBelowMe() {
		return firstBelowMe;
	}

	public int getGradientGene() {
		return gradientGene;
	}

	public double getHeight() {
		return height;
	}

	public AtomKind getKind() {
		return kind;
	}

	public Atom getNextLikeMe() {
		return nextLikeMe;
	}

	public double getWidth() {
		return width;
	}

	/**
	 * 
	 * <h2>Original Documentation</h2>
	 * <p>
	 * Destroy this animal. Mark all of its Atoms as Free again.
	 * </p>
	 * <p>
	 * Recursively step through the animal
	 * </p>
	 */
	public void kill() {
		if (firstBelowMe != null) {
			firstBelowMe.kill();
			firstBelowMe = null;
		}
		if (nextLikeMe != null) {
			nextLikeMe.kill();
			nextLikeMe = null;
		}
	}

	public void setAngle(double angle) {
		this.angle = angle;
	}

	public void setFirstBelowMe(Atom firstBelowMe) {
		this.firstBelowMe = firstBelowMe;
	}

	public void setGradientGene(int gradientGene) {
		this.gradientGene = gradientGene;
	}

	public void setHeight(double height) {
		this.height = height;
	}

	public void setKind(AtomKind kind) {
		this.kind = kind;
	}

	public void setNextLikeMe(Atom nextLikeMe) {
		this.nextLikeMe = nextLikeMe;
	}

	public void setWidth(double width) {
		this.width = width;
	}

	public void recurseToStringBuffer(StringBuffer text, int recurseLevel) {
		text.append(kind.toString() + " w:" + width + " h:" + height + " a:" + angle + " g:" + gradientGene + " segNo:" + segmentNumber
				+ " atomCount:" + countAtoms());
		
		if(firstBelowMe != null) {
			text.append("<br>\n");
			for(int i = 0; i < recurseLevel; i++) {
				text.append("&gt;");
			}
			firstBelowMe.recurseToStringBuffer(text, recurseLevel + 1);
		}
		if(nextLikeMe != null) {
			text.append("<br>\n");
			for(int i = 0; i < recurseLevel - 1; i++) {
				text.append("&gt;");
			}
			nextLikeMe.recurseToStringBuffer(text, recurseLevel + 1);
		}
	}
	
	@Override
	public String toString() {
		StringBuffer text = new StringBuffer();
		recurseToStringBuffer(text, 0);

		return text.toString();
	}

	public Vector<Atom> toVector() {
		Vector<Atom> atoms = new Vector<Atom>();
		atoms.add(this);
		if (firstBelowMe != null)
			atoms.addAll(firstBelowMe.toVector());
		if (nextLikeMe != null)
			atoms.addAll(nextLikeMe.toVector());
		return atoms;
	}

}
