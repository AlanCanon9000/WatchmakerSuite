package net.richarddawkins.watchmaker.morph.mono.geom;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;

import net.richarddawkins.watchmaker.morph.Morph;
import net.richarddawkins.watchmaker.morph.biomorph.genome.BiomorphGenome;
import net.richarddawkins.watchmaker.morph.biomorph.genome.type.CompletenessType;
import net.richarddawkins.watchmaker.morph.biomorph.genome.type.SpokesType;
import net.richarddawkins.watchmaker.morph.biomorph.geom.Lin;
import net.richarddawkins.watchmaker.morph.biomorph.geom.Point;
import net.richarddawkins.watchmaker.morph.biomorph.geom.gui.SimpleSwingPic;
import net.richarddawkins.watchmaker.morph.mono.genome.MonochromeGenome;
import net.richarddawkins.watchmaker.morph.util.Globals;

public class MonoPic extends SimpleSwingPic {
    public MonoPic(Morph morph) {
        super(morph);
    }
    @Override
    public void picLine(int x, int y, int xnew, int ynew, int thick, Color color) {
        if (thick > 8) {
            thick = 8;
        }
        if (lines.size() >= PICSIZEMAX) {
            // {Message(GetString(TooLargeString));}
            // {used the help dialog! v1.1 changed to alert}
            // DisplayError(-147, 'Biomorph too large, or other problem', '
            // ', StopError);
            // ExitToShell
        } else {
            addPicLines(x, y, xnew, ynew, thick, color);
        }
    }


    public void addPicLines(int x, int y, int xnew, int ynew, int thick, Color color) {
        BiomorphGenome genome = (BiomorphGenome) morph.getGenome();
        addActualPicLine(x, y, xnew, ynew, thick, color, picStyle, Compass.NorthSouth);
        // sometimes rangecheck error

        if (genome.getSpokesGene().getValue() == SpokesType.Radial) {
            if (genome.getCompletenessGene().getValue() == CompletenessType.Single) {
                addActualPicLine(x, y, xnew, ynew, thick, color, PicStyleType.RUD, Compass.EastWest);
            } else {
                addActualPicLine(x, y, xnew, ynew, thick, color, picStyle, Compass.EastWest);
            }
        }

    }
    
    private void addActualPicLine(int x, int y, int xnew, int ynew, int thick, Color color, PicStyleType picStyle,
            Compass orientation) {
        int y0;
        int y1;
        int x0;
        int x1;
        Point place = new Point(0,0);
        if (orientation == Compass.NorthSouth) {
            int horizOffset = origin.h - place.h;
            int vertOffset = origin.v - place.v;
            x0 = x - horizOffset;
            y0 = y - vertOffset;
            x1 = xnew - horizOffset;
            y1 = ynew - vertOffset;
        } else {
            int horizOffset = origin.v - place.h;
            int vertOffset = origin.h - place.v;
            x0 = y - horizOffset;
            y0 = x - vertOffset;
            x1 = ynew - horizOffset;
            y1 = xnew - vertOffset;
        }

        int mid2 = 2 * place.h;
        int belly2 = 2 * place.v;

        switch (picStyle) {
        case LF:
            addSinglePicLine(new Point(x0, y0), new Point(x1, y1), thick, color);
            break;
        case RF:
            addSinglePicLine(new Point(mid2 - x0, y0), new Point(mid2 - x1, y1), thick, color);
            break;
        case FF:
            addSinglePicLine(new Point(x0, y0), new Point(x1, y1), thick, color);
            addSinglePicLine(new Point(mid2 - x0, y0), new Point(mid2 - x1, y1), thick, color);
            break;
        case LUD:
            addSinglePicLine(new Point(x0, y0), new Point(x1, y1), thick, color);
            addSinglePicLine(new Point(mid2 - x0, belly2 - y0), new Point(mid2 - x1, belly2 - y1), thick, color);
            break;
        case RUD:
            addSinglePicLine(new Point(mid2 - x0, y0), new Point(mid2 - x1, y1), thick, color);
            addSinglePicLine(new Point(x0, belly2 - y0), new Point(x1, belly2 - y1), thick, color);
            break;
        case FUD:
            addSinglePicLine(new Point(x0, y0), new Point(x1, y1), thick, color);
            addSinglePicLine(new Point(mid2 - x0, y0), new Point(mid2 - x1, y1), thick, color);
            addSinglePicLine(new Point(x0, belly2 - y0), new Point(x1, belly2 - y1), thick, color);
            addSinglePicLine(new Point(mid2 - x0, belly2 - y0), new Point(mid2 - x1, belly2 - y1), thick, color);
            break;
        default:
        }

        
    }

    private void addSinglePicLine(Point startPt, Point endPt, int thick, Color color) {
        lines.add(new Lin(startPt, endPt, thick, color));
        margin.expandPoint(startPt, thick);
        margin.expandPoint(endPt, thick);
    }
    /**
     * Pic already contains its own origin, meaning the coordinates at which it
     * was originally drawn. Now draw it at Place
     */
    @Override
    public void drawPic(Graphics2D g2, Point d, Point place) {
        for (Lin line : lines) {
            g2.setStroke(new BasicStroke(line.thickness));
            g2.setColor(line.color);
            g2.drawLine(line.startPt.h, line.startPt.v, line.endPt.h, line.endPt.v);

        }

    }


    
    
}
