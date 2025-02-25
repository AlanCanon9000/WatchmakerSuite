package net.richarddawkins.watchmaker.morphs.arthro.genome.mutation;

import static net.richarddawkins.watchmaker.genome.mutation.Random.randInt;

import java.util.logging.Level;
import java.util.logging.Logger;

import net.richarddawkins.watchmaker.genome.Genome;
import net.richarddawkins.watchmaker.genome.mutation.AllowedMutations;
import net.richarddawkins.watchmaker.genome.mutation.SimpleMutagen;
import net.richarddawkins.watchmaker.morphs.arthro.genome.ArthromorphGenome;
import net.richarddawkins.watchmaker.morphs.arthro.genome.Atom;
import net.richarddawkins.watchmaker.morphs.arthro.genome.type.AtomKind;

public class ArthromorphMutagen extends SimpleMutagen {

	private static Logger logger = Logger
			.getLogger("net.richarddawkins.watchmaker.morphs.arthro.genome.mutation.ArthromorphMutagen");

	public ArthromorphMutagen(AllowedMutations allowedMutations) {
		super(allowedMutations);
	}

	protected double getFactor() {
		ArthromorphAllowedMutations muts = (ArthromorphAllowedMutations) allowedMutations;
		int choose = 0;
		switch (muts.mutationPressure) {
		case Positive:
			choose = 2 + randInt(2);
			break;
		case Zero:
			choose = randInt(4);
			break;
		case Negative:
			choose = randInt(2);
		}
		// Richard, you can play with these factors
		switch (choose) {
		case 1:
			return 0.50;
		case 2:
			return 0.9;
		case 3:
			return 1.1;
		case 4:
			return 1.5;
		}
		return 1;
	}

	/**
	 * <h2>Original documentation</h2>
	 * 
	 * <pre>
	 * Mutate first picks an atom randomly from the Animal.
	 * 	From num of atoms, picks one and step down to it
	 * 		Flip a coin for what to do: change Height, Width, Angle, Dup part, Delete part, Flip angle
	 * 			Test if legal to do it and do it (else return false)
	 * 				Delete does not delete the first-and-only of its Kind
	 * Forbid: Angle mod if none, delete last Section, or Seg
	 * 		Delete Animal, Dup Animal,   Delete Claw, Dup Claw
	 * Range limits on some modifications??  Only angles can be negative.
	 * </pre>
	 */

	Atom secondSegmentAtom = null;
	protected int segmentCounter = 0;

	public void countSeg(Atom atom) {
		if (atom.kind == AtomKind.SegmentTrunk) {
			atom.segmentNumber = ++segmentCounter;
		}
		if (atom.firstBelowMe != null)
			countSeg(atom.firstBelowMe);
		if (atom.nextLikeMe != null && atom.kind != AtomKind.AnimalTrunk)
			countSeg(atom.nextLikeMe);
	}

	protected int findNthCount = -1;

	protected int secondSegmentAtomNo = -1;

	/**
	 * Travel over the Animal, counting Atoms and return the Nth
	 * 
	 * @param which
	 * @param pick
	 * @return
	 */
	protected Atom findNth(Atom which, int pick) {
		findNthCount++;
		Atom found = null;
		if (which.kind == AtomKind.SegmentTrunk)
			segmentCounter++;
		if (segmentCounter == 2)
			secondSegmentAtomNo = findNthCount;
		if (findNthCount >= pick) {
			found = which;
		} else {
			if (which.firstBelowMe != null)
				found = findNth(which.firstBelowMe, pick);
			if (findNthCount < pick)
				if (which.nextLikeMe != null)
					found = findNth(which.nextLikeMe, pick);
			if (findNthCount < pick)
				found = null; // not there yet
		}
		return found;
	}

	public boolean mutate(Genome genome) {
		int counter = 0;
		boolean done = false;
		do {
			counter++;
			// If it fails, just try again until we succeed at changing
			// something. - RD
			done = tryMutate(genome);

		} while (!done && counter <= 1000);

		if (counter > 1000) {
			logger.log(Level.WARNING, "Timed out, perhaps attempting impossible duplication or deletion");
		}
		return done;
	}

	public boolean tryMutate(Genome genome) {
		ArthromorphGenome targetGenome = (ArthromorphGenome) genome;
		// size, pick, count, target, change, extraclaw, thisSegment,
		// lastSegment, AtomNumber: integer;
		// this, targetAtom: Atom;
		// ok, mutOK, CouldBe: boolean;
		// factor: real;
		// begin
		// this = BoneYard[which]^^;
		Atom animalTrunk = targetGenome.getAnimalTrunk();

		if (animalTrunk.kind != AtomKind.AnimalTrunk)
			try {
				throw new Exception("Not an animal");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		int atomNumber = animalTrunk.countAtoms();
		int lastSegment = segmentCounter;
		int size = atomNumber; // As a convention, we keep the number of Atoms
								// in this animal in
								// AnimalTrunk's Angle field
		int pick = randInt(size) - 1; // a number from 0 to size - 1. Index of
										// the atom we will modify
		findNthCount = 0;
		Atom target = findNth(animalTrunk, pick); // find the Nth atom
		if (target == null)
			try {
				throw new Exception("Atom count is wrong.  Fatal.  Quitting");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} // Aren't pick atoms in this Animal

		// Decide what to do
		int change = randInt(7); // seven basic operations
		
		// 1 twiddle Height, 2 twiddle Width, 3 twiddle Angle, 4 Duplicate
		// entire subtree, 5 Delete
		// subtree
		// 6 reverse an angle , 7 reverse sign of Gradient
		
		// TODO FIXME
//		change = 4; // For testing only, force duplication.
		
		if (change == 7 && target.kind == AtomKind.AnimalTrunk) {
			target.setGradientGene(-target.getGradientGene());
		}

		if (change == 4) {
			// If Dup and target is second or third part of an Animal, Section,
			// or Segment,}
			// Then jump down to the next part of the animal}
			if (target.kind == AtomKind.AnimalJoint || target.kind == AtomKind.SectionJoint
					|| target.kind == AtomKind.SegmentJoint) {
				target = target.nextLikeMe; // AnimalClaw
			}
			if (target.kind == AtomKind.AnimalClaw || target.kind == AtomKind.SectionClaw
					|| target.kind == AtomKind.SegmentClaw) {
				target = target.firstBelowMe;
			}
			// SectionTrunk .. where we want to be
		}
		boolean mutOK = false;
		ArthromorphAllowedMutations muts = (ArthromorphAllowedMutations) allowedMutations;
		switch (target.kind) {
		case AnimalTrunk:
			if (muts.animalTrunkMut)
				mutOK = true;
			break;
		case AnimalJoint:
			if (muts.animalLegsMut)
				mutOK = true;
			break;
		case AnimalClaw:
			if (muts.animalClawsMut)
				mutOK = true;
			break;
		case SectionTrunk:
			if (muts.sectionTrunkMut)
				mutOK = true;
			break;
		case SectionJoint:
			if (muts.sectionLegsMut)
				mutOK = true;
			break;
		case SectionClaw:
			if (muts.sectionClawsMut)
				mutOK = true;
			break;
		case SegmentTrunk:
			if (muts.segmentTrunkMut)
				mutOK = true;
			break;
		case SegmentJoint:
			if (muts.segmentLegsMut)
				mutOK = true;
			break;
		case SegmentClaw:
			if (muts.segmentClawsMut)
				mutOK = true;
			break;
		case Joint:
			if (muts.legsMut)
				mutOK = true;
			break;
		case Claw:
			if (muts.clawsMut)
				mutOK = true;
			break;
		default:
			mutOK = false;
		}

		switch (muts.focusOfAttention) {
		case FirstSegmentOnly:
			if (secondSegmentAtomNo > -1) {
				if (findNthCount < secondSegmentAtomNo) {
					boolean couldBe = (target.kind == AtomKind.SegmentTrunk || target.kind == AtomKind.SegmentJoint
							|| target.kind == AtomKind.SegmentClaw || target.kind == AtomKind.Joint
							|| target.kind == AtomKind.Claw);
					if (!couldBe)
						mutOK = false;
				}
			} else {
				mutOK = false;
			}
			break;
		case LastSegmentOnly:
			if (segmentCounter != lastSegment)
				mutOK = false;
			break;
		case AnySegment:
			// // No need for action. mutOK retains its present value
		}
		boolean ok = false;
		if (mutOK) {
			ok = true;
			if ((change == 4 || change == 5) && target.kind == AtomKind.Claw) {
				ok = false; // Forbid delete or dup of claw
			}
			if ((change == 3 || change == 6)
					&& (target.kind == AtomKind.AnimalTrunk || target.kind == AtomKind.SegmentTrunk)) {
				// These atoms have no Angle part. SectionTrunk does, because
				// 'angle' is overlap, by
				// convention
				ok = false;
			}
			if (ok) {
				if (change == 4) {
					if (muts.duplicationMut) {
						if (target.kind == AtomKind.AnimalTrunk) {
							// Special case, means GradientFactor
							target.setGradientGene(target.getGradientGene() + 1);
						} else {
							// Insert copy of me after me
							// CopyExceptNext makes sure NextLikeMe of copy now
							// points to old NextLikeMe of target
							// So brothers are kept, and new subtree is inserted
							// last joint has claw. When duplicate, get rid of extra claw
							target.nextLikeMe = target.copyExceptNext(target.getGenome()); 
						}
						
						if (target.kind == AtomKind.Joint && target.firstBelowMe != null) { 
							Atom extraClaw = target.firstBelowMe;
							target.firstBelowMe = null;
							extraClaw.kill();
						}
						targetGenome.setAtomCount(animalTrunk.countAtoms());
						// A little wasteful to count entire animal again
					} else {
						ok = false;
					}
				}
				if (change < 4) {
					double factor = getFactor(); // See table above
					switch (change) {
					case 1:
						if (muts.heightMut)
							target.height *= factor;
						else
							ok = false;
						break;
					case 2:
						if (muts.widthMut)
							target.width *= factor;
						else
							ok = false;
						break;
					case 3:
						if (muts.angleMut) {
							target.angle *= factor;
							if (target.kind == AtomKind.SectionTrunk) {
								target.angle = Math.abs(target.angle); // forbid
																		// backward
																		// overlaps
								if (target.angle > 1)
									target.angle = 1; // Otherwise disembodied
														// segments
							}
						} else {
							ok = false;
						}
					}
				}
				if (change == 5) {
					if (muts.deletionMut) {
						if (target.kind == AtomKind.AnimalTrunk)
							target.setGradientGene(target.getGradientGene() - 1);

						// Delete. Complex because we need to talk to the atom
						// above where we delete}
						ok = target.doDelete(); // there is a problem here
						if (ok)
							targetGenome.setAtomCount(animalTrunk.countAtoms());
						// A little wasteful to count entire animal again
					} else {
						ok = false;
					}
				}
				if (change == 6 && target.kind != AtomKind.SectionTrunk) {
					if (muts.angleMut)
						target.angle *= -1.0; // reverse an angle
					else
						ok = false;
				}
			}
		}
		countSeg(animalTrunk);

		return ok && mutOK;
	}

}
