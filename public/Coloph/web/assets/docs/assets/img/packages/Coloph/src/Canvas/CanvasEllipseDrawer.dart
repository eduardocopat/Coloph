part of coloph;

class CanvasEllipseDrawer{
  CanvasRenderingContext2D ctx;
  
  CanvasEllipseDrawer(CanvasRenderingContext2D ctx){
    this.ctx = ctx;
  }
  
  // http://stackoverflow.com/questions/2172798/how-to-draw-an-oval-in-html5-canvas
  // Nicer elipse? http://stackoverflow.com/questions/14424648/nice-ellipse-on-a-canvas
  // http://stackoverflow.com/questions/2172798/how-to-draw-an-oval-in-html5-canvas
  //Shadow ellipse
  void draw(num x, num y, num w, num h, String fillStyle, String strokeStyle, bool dashed) {
    num kappa = .5522848,
        ox = (w / 2) * kappa, // control point offset horizontal
        oy = (h / 2) * kappa, // control point offset vertical
        xe = x + w,           // x-end
        ye = y + h,           // y-end
        xm = x + w / 2,       // x-middle
        ym = y + h / 2;       // y-middle
    
    ctx.lineWidth = GOLDEN_RATIO;
    if(dashed){
      ctx.setLineDash([4]);
      ctx.lineDashOffset = 1;
      ctx.lineWidth = 2.5;
    }
    
    ctx.beginPath();
    ctx.moveTo(x, ym);
    ctx.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
    ctx.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
    ctx.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
    ctx.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
    ctx.fillStyle = fillStyle;
    ctx.strokeStyle = strokeStyle;
    ctx.fill();
    ctx.closePath();
    ctx.stroke();
 
    //Default
    ctx.lineWidth = 1;
    ctx.setLineDash([]);
    ctx.strokeStyle = 'black';
    ctx.fillStyle = 'black';
  }
}