package net.richarddawkins.watchmaker.morphs.arthro.swing;

import java.awt.event.ActionEvent;

import javax.swing.JFrame;

import net.richarddawkins.watchmaker.swing.menu.SwingWatchmakerAction;

public class EngineerAction extends SwingWatchmakerAction {


	private static final long serialVersionUID = 1L;
	public static JFrame frame = null;
	public EngineerAction() {
		super("Allowed Mutations");
	}
	@Override
	public void actionPerformed(ActionEvent e) {
		if(frame == null) {
			frame = new ArthromorphsEngineer(getAppData());
	
			frame.setDefaultCloseOperation(JFrame.HIDE_ON_CLOSE);
	
			frame.pack();
		}
		frame.setVisible(true);
		
	}

}
