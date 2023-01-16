using Beefy;
using Beefy.gfx;
using Beefy.widgets;
namespace CellarId;

class CIDApp : BFApp
{
	public Image mTemplateImage ~ delete _;
	public WidgetWindow mMainWindow;
	public DrawLayer mDrawLayer ~ delete _;
	public Font mCodeFont ~ delete _;

	public override void Init()
	{
		base.Init();

		mCodeFont = new .();
		mCodeFont.Load("Consolas", 30);

		Board board = new Board();
		mMainWindow = new .(null, "CellarID QR Generator", 50, 50, 2550/4, 3300/4, .Caption | .Resizable | .ClientSized | .SysMenu | .QuitOnClose, board);

		mTemplateImage = Image.LoadFromFile("images/template.jpg");

		Image img = Image.CreateRenderTarget(2550, 3300);
		//DrawLayer_DrawToRenderTarget();

		mDrawLayer = new DrawLayer(mMainWindow);
		//mDrawLayer.DrawToRenderTarget(img);
		board.mImage = img;

		var g = gApp.mGraphics;
	}
}