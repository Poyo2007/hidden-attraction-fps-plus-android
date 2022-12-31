package;

import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import openfl.utils.Assets;

/**
	Creates textures that exist only in VRAM and not standard RAM.
	Originally written by Smokey, additional developement by Rozebud.
**/
class GPUBitmap
{
	private static var textureCache:Map<String, Texture> = [];

	/**
	 * Creates a `BitmapData` for a `IMAGE` and deletes the reference stored in RAM leaving only the texture in VRAM.
	 * 
	 * @param path The file path.
	 * @param optimized Generates mipmaps.
	 *
	 * @return A `BitmapData` object that uses the loaded texture from the VRAM.
	 */
	public static function create(path:String, optimized:Bool = true):BitmapData
	{
		if (Assets.exists(path, IMAGE))
		{
			if (!textureCache.exists(path))
			{
				var bitmapData:BitmapData = Assets.getBitmapData(path, false);

				var texture:Texture = Lib.current.stage.context3D.createTexture(bitmapData.width, bitmapData.height, BGRA, optimized, 0);
				texture.uploadFromBitmapData(bitmapData);

				if (bitmapData != null)
				{
					bitmapData.dispose();
					bitmapData.disposeImage();
					bitmapData = null;
				}

				textureCache.set(path, texture);
			}
			else
				trace('$path is already loaded!');

			return BitmapData.fromTexture(textureCache.get(path));
		}
		else
			trace('$path is null!');

		return null;
	}

	public static function dispose(type:DisposeType):Void
	{
		for (path in textureCache.keys())
		{
			switch (type)
			{
				case ALL:
					var obj:Null<Texture> = textureCache.get(path);
					obj.dispose();
					obj = null;
					textureCache.remove(path);
				case KEY(key):
					var obj:Null<Texture> = textureCache.get(key);
					if (textureCache.exists(key) && obj != null)
					{
						obj.dispose();
						obj = null;
						textureCache.remove(key);
					}
			}
		}
	}
}

enum DisposeType
{
	ALL;
	KEY(key:String);
}
