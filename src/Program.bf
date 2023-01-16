using System;
using System.Security.Cryptography;
using System.Diagnostics;
using Beefy.gfx;
using Beefy;
using Beefy.widgets;
using System.Collections;

namespace CellarId;


class Program
{
	[CallingConvention(.Stdcall), CLink]
	public extern static uint32* Res_LoadImage(char8* fileName, out int32 width, out int32 height);

	[CallingConvention(.Stdcall), CLink]
	public extern static Span<uint8> Res_JPEGCompress(uint32* bits, int width, int height, int quality);

	public static int Main(String[] args)
	{
		gApp = scope .();
		gApp.Init();
		gApp.Run();
		gApp.Shutdown();
		return 0;
	}
}

static
{
	public static CIDApp gApp;
}