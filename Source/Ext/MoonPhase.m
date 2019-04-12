//
//  MoonPhase.m
//  Mijn Hemel
//
//  Created by Norbert Schmidt on 26-11-12.
//  Copyright (c) 2012 Norbert Schmidt. All rights reserved.
//


#import "MoonPhase.h"

float fixangle( float angle ){
	return angle - 360.0f * ( floor ( angle / 360.0f ) );
}

float torad( float deg ){
	return deg * ( M_PI / 180.0f );
}

float todeg( float rad ){
	return rad * ( 180.0f / M_PI );
}

float dsin( float deg ){
	return sin( torad( deg ) );
}

double jtime( double t ){
	return (t / 86400.0f) + 2440587.5f;
}

float kepler( float m, float ecc ){
	float EPSILON = 0.000001f;
	m = torad(m);
	float e = m;
	float delta;
	
	// first time
	delta = e - ecc * sin(e) - m;
	e -= delta / ( 1.0f - ecc * cos(e) );
	
	// loop
	while( fabsf(delta) > EPSILON ){
		delta = e - ecc * sin(e) - m;
		e -= delta / ( 1.0f - ecc * cos(e) );
	}
	
	return e;
}

@implementation MoonPhase

- (id) init {
    self = [super init];
    if (self) {

		now = [NSDate date];
   
    
    }
    return self;
}

- (void) dealloc {
}




- (float) elongation {
	// const
    
    now = [NSDate date];
	double Epoch = 2444238.5;
	float Elonge = 278.833540;
	float Elongp = 282.596403;
	float Eccent = 0.016718;
	float Mmlong = 64.975464;
	float Mmlongp = 349.383063;
	float Mlnode = 151.950429;
	float Minc = 5.145396;
	float Synmonth = 29.53058868;// synodic month (new Moon to new Moon)

	NSTimeInterval d = [now timeIntervalSince1970];
    
	double pdate = jtime( (float)d );
    
    
    // NSLog (@"Pdate  %f", pdate);
    
	double Day = pdate - Epoch;
	
    
    
    
    
	double N = fixangle( ( 360.0f / 365.2422f ) * Day );
	double M = fixangle( N + Elonge - Elongp );
	double Ec = kepler( M, Eccent );
	Ec = sqrt( ( 1.0f + Eccent ) / ( 1.0f - Eccent ) ) * tan( Ec / 2.0f );
	Ec = 2.0f * todeg( atan( Ec ) );
	double Lambdasun = fixangle( Ec + Elongp );
    
	double ml = fixangle( 13.1763966f * Day + Mmlong );
	double MM = fixangle( ml - 0.1114041f * Day - Mmlongp );
	double MN = fixangle( Mlnode - 0.0529539f * Day );
	double Ev = 1.2739f * sin( torad( 2.0f * ( ml - Lambdasun ) - MM ) );
	double Ae = 0.1858f * sin( torad( M ) );
	double A3 = 0.37f * sin( torad( M ) );
	double MmP = MM + Ev - Ae - A3;
	double mEc = 6.2886f * sin( torad( MmP ) );
	double A4 = 0.214f * sin( torad( 2.0f * MmP ) );
	double lP = ml + Ev + mEc - Ae + A4;
	double V = 0.6583f * sin( torad( 2.0f * ( lP - Lambdasun ) ) );
	double lPP = lP + V;
	double NP = MN - 0.16f * sin( torad( M ) );
	double y = sin( torad( lPP - NP ) ) * cos( torad( Minc ) );
	double x = cos( torad( lPP - NP ) );
	double Lambdamoon = todeg( atan2( y, x ) );
	Lambdamoon += NP;
	
	double MoonAge = lPP - Lambdasun;
    
    
    //	$mage = $Synmonth * (Moon::fixangle($MoonAge) / 360.0); # age of moon in days
    
    float mage=Synmonth  * fixangle(MoonAge)/360.0;
    
    // elongatie west
    
    
    
    
    /*
    // . A simple, but low precision method of calculating elongation is to take the age of the Moon in days past New Moon and multiply it times 13.18°. This will give the elongation east of the Sun.
    // 14= vol 29 new
    
    The age of the Moon is the number of days since the last new moon. Since the phases of the Moon cycle roughly once every 29 days, the Moon is full when it is around 14 days old, and is approaching new moon again by the time is approaches an age of 29 days. Usually this four-week cycle is further subdivided into four week-long sections by the times when the Moon is exactly half illuminated, at the midpoints between new and full moon, when its age is 7 days (first quarter) and 21 days (last quarter). 
    */
    // westelijke elongatie
    
    double elon=0;
    
    if (mage<14) {
        elon=mage*torad(13.18);
    }
    if (mage>=14) {
        elon=Synmonth-mage;
        elon=elon*torad( 13.18);
        
    }
    
    double elongationinhours=todeg(elon)/15;
    // Moonset (rise) = sunset (rise) + elongation in hours

    
    NSLog (@"Elong: %.2f", todeg(elon));
    
    NSLog (@"Hours: %.2f", elongationinhours);
    
    
    
    return elongationinhours;
    
    

    
}



- (float) phase {
	// const
    
    now = [NSDate date];
	double Epoch = 2444238.5;
	float Elonge = 278.833540;
	float Elongp = 282.596403;
	float Eccent = 0.016718;
	float Mmlong = 64.975464;
	float Mmlongp = 349.383063;
	float Mlnode = 151.950429;
	float Minc = 5.145396;
	
	NSTimeInterval d = [now timeIntervalSince1970];
    
	double pdate = jtime( (float)d );
    
    
    // NSLog (@"Pdate  %f", pdate);
    
	double Day = pdate - Epoch;
	
    
    
    
    
	double N = fixangle( ( 360.0f / 365.2422f ) * Day );
	double M = fixangle( N + Elonge - Elongp );
	double Ec = kepler( M, Eccent );
	Ec = sqrt( ( 1.0f + Eccent ) / ( 1.0f - Eccent ) ) * tan( Ec / 2.0f );
	Ec = 2.0f * todeg( atan( Ec ) );
	double Lambdasun = fixangle( Ec + Elongp );
    
	double ml = fixangle( 13.1763966f * Day + Mmlong );
	double MM = fixangle( ml - 0.1114041f * Day - Mmlongp );
	double MN = fixangle( Mlnode - 0.0529539f * Day );
	double Ev = 1.2739f * sin( torad( 2.0f * ( ml - Lambdasun ) - MM ) );
	double Ae = 0.1858f * sin( torad( M ) );
	double A3 = 0.37f * sin( torad( M ) );
	double MmP = MM + Ev - Ae - A3;
	double mEc = 6.2886f * sin( torad( MmP ) );
	double A4 = 0.214f * sin( torad( 2.0f * MmP ) );
	double lP = ml + Ev + mEc - Ae + A4;
	double V = 0.6583f * sin( torad( 2.0f * ( lP - Lambdasun ) ) );
	double lPP = lP + V;
	double NP = MN - 0.16f * sin( torad( M ) );
	double y = sin( torad( lPP - NP ) ) * cos( torad( Minc ) );
	double x = cos( torad( lPP - NP ) );
	double Lambdamoon = todeg( atan2( y, x ) );
	Lambdamoon += NP;
	
	double MoonAge = lPP - Lambdasun;
	double MoonPhase = (1 - cos(torad(MoonAge))) / 2;	// Phase of the Moon
    
 //   NSLog (@"MoonPhase %f", MoonPhase);

    
    MoonPhase=round(MoonPhase*100);
    
	return MoonPhase;
}

@end
