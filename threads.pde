import ddf.minim.*;
import ddf.minim.analysis.*;

Minim        minim;
AudioPlayer  player;
FFT          fft;
FFTContainer fftc;

ArrayList<Line> lines = new ArrayList<Line>();
float delta = 0;

void setup() {
  size(1280, 720, P3D);
  pixelDensity(displayDensity());
  minim = new Minim(this);
  filter(BLUR, 5);
  smooth(8);
  setup_audio();
}

void setup_audio() {
  player = minim.loadFile("spaced_out.mp3", 2048);
  player.play();

  fft = new FFT(player.bufferSize(), player.sampleRate());

  // Iterate once for each of the 8 threads.
  for (int i = 0; i < 16; i++) {
    int dy = i * 96;
    
    Point p1 = new Point(0, dy, 0);
    Point p2 = new Point(200, dy, 0);

    Line line = new Line(p1, p2, 50, 25);
    
    lines.add(line);
  }

  fftc = new FFTContainer(32); // 32 points per line
}

void draw() {
  rotate(1.56);
  translate(-20, -1340, -420); 
  background(0);
  strokeWeight(1); 
  noFill();

  fft.forward(player.mix);

  FFTLine fft_line = new FFTLine(32); // 32 points per line

  for (int j = 0; j < 32; j++) {
    int target = int(map(j, 0, 32, 0, fft.specSize()));
    
    float fft_point = fft.getBand(target) * 100; // multiplying the point height will give a more dramatic effect for lower amplitudes
    
    fft_line.add_at(j, fft_point);
  }

  fftc.add(fft_line);
  fftc.trim();

  FFTLine current_fft;

  // Iterate once for each of the 8 threads.
  for (int i = 0; i < 16; i++) {
    beginShape();
        
    current_fft = fftc.get(i);
    for (int pt = 1; pt < 32 - 1; pt++) {
      Point p = lines.get(i).get_point(pt);

      if (current_fft != null) {
        delta = current_fft.get_at(pt);
      }
      
      
      curveVertex(p.x, p.y, delta < 100000 ? delta / 10 : delta);
      
      stroke(255 - (i * 5), 100 - (i * 10), (i * 10));;
    }

    endShape();
  }
  
  //saveFrame("frames/frame-######.tif");
}
