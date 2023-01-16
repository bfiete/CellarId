using Beefy.widgets;
using Beefy.gfx;
using System.Collections;
using System;
using System.Security.Cryptography;
using System.Diagnostics;
using System.IO;

namespace CellarId;

class Board : Widget
{
	public Image mImage ~ delete _;
	public int32 mDrawCount;
	public List<Image> mImages = new .() ~ DeleteContainerAndItems!(_);
	public List<String> mCodes = new .() ~ DeleteContainerAndItems!(_);

	public override void Draw(Graphics g)
	{
		mDrawCount++;

		if (mImages.IsEmpty)
		{
			String chars = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";

			//for (int codeIdx < 80)
			for (int codeIdx < 4)
			{
				var hash = MD5.Hash(.((.)(&codeIdx), 4));
				int64 val = Math.Abs(*(int64*)&hash);

				String code = scope .();
				for (int i < 8)
				{
					code.Append(chars[val % chars.Length]);
					val /= chars.Length;
				}

				ProcessStartInfo startInfo = scope .();
				startInfo.SetFileName("SimpleCodeGenerator.exe");
				//startInfo.SetArguments(scope $"/ErrorCorrection 1 /Save https://cellarid.com/{code} codes/{code}.png 1");
				startInfo.SetArguments(scope $"/ErrorCorrection 1 /Save https://cellarid.com/{code} codes/{code}.png 7");
				//startInfo.SetArguments(scope $"/ErrorCorrection 2 /Save http://q.wine/{code} codes/{code}.png 1");
				//startInfo.SetArguments(scope $"/ErrorCorrection 1 /Save www.q.wine/{code} codes/{code}.png 1");

				SpawnedProcess process = scope SpawnedProcess();
				process.Start(startInfo);
				process.WaitFor();

				var qrImage = Image.LoadFromFile(scope $"codes/{code}.png");

				String codeStr = new .(code);
				codeStr.Insert(4, "-");
				mCodes.Add(codeStr);

				mImages.Add(qrImage);
			}
		}

		//if (mDrawCount < 2)
		{
			using (g.PushDrawLayer(gApp.mDrawLayer))
			{
				using (g.PushColor(0xFFFFFFFF))
					g.FillRect(0, 0, mImage.mWidth, mImage.mHeight);

				//g.Draw(gApp.mTemplateImage, -4, -6);

				g.SetFont(gApp.mCodeFont);

				for (int codeIdx < mImages.Count)
				{
					float x = (codeIdx % 8) * 300 + 112;
					float y = (codeIdx / 8) * 300 + 177;

					var qrImage = mImages[codeIdx];
					//using (g.PushColor(0x80FFFFFF))
						g.Draw(qrImage, x, y);

					using (g.PushColor(0xFF000000))
						g.DrawString(mCodes[codeIdx], x + 109, y + 196, .Centered);
				}
			}

			gApp.mDrawLayer.DrawToRenderTarget(mImage);
		}
		
		/*using (g.PushColor(0xFF000060))
			g.FillRect(0, 0, mWidth, mHeight);*/

		g.Draw(mImage, 0, 0);

		if (mDrawCount == 1)
		{
			uint32* bits = new uint32[(.)(mImage.mWidth * mImage.mHeight)]*;
			defer delete bits;
			mImage.GetBits(0, 0, (.)mImage.mWidth, (.)mImage.mHeight, (.)mImage.mWidth, bits);

			var jpegBits = Program.Res_JPEGCompress(bits, (.)mImage.mWidth, (.)mImage.mHeight, 90);
			File.WriteAll("page.jpg", jpegBits);
		}
	}
}
