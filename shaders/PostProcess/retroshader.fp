vec4 pixelate(sampler2D tex, float spread)
{

ivec2 ssize = textureSize( InputTexture, 0 );

vec2 coord = vec2(ceil(TexCoord.x*ssize.x/pixelcount)/ssize.x*pixelcount,ceil(TexCoord.y*ssize.y/pixelcount)/ssize.y*pixelcount);

vec2 dcoord;
dcoord = vec2( (TexCoord.x*ssize.x/pixelcount ) ,
			   (TexCoord.y*ssize.y/pixelcount ) );
ivec2 d_coord = ivec2( dcoord.x, dcoord.y );

ivec2 dsize = textureSize( Bayer, 0 );

d_coord.x -= int ( floor(float(d_coord.x/dsize.x)) )*dsize.x;
d_coord.y -= int ( floor(float(d_coord.y/dsize.y)) )*dsize.y;

float dth = 1.0+(0.5-texelFetch(Bayer, d_coord, 0 ).r)/(33.5-spread);

return texture(tex, coord)*dth;
}

void main() 
{
	if ( enablepixelate == 1 )
	{
		if ( enableposterization == 1 )
		{
			vec4 c = pixelate(InputTexture, dspread);
			c = pow(c, vec4(gamma, gamma, gamma, 1));
			c = c * posterization;
			c = floor(c);
			c = c / posterization;
			c = pow(c, vec4(1.0/gamma));
			FragColor = vec4(c);
		}
		if ( enableposterization == 0 )
		{
			FragColor = pixelate(InputTexture, dspread);
		}
	}
	if ( enablepixelate == 0 )
	{
		vec4 c = texture(InputTexture, TexCoord.xy);
		c = pow(c, vec4(gamma, gamma, gamma, 1));
		c = c * posterization;
		c = floor(c);
		c = c / posterization;
		c = pow(c, vec4(1.0/gamma));
		FragColor = vec4(c);
	}
}