
# how to run

run test.m

//change starting shape by setting 1 to 0 or 0 to 1
arrStartingShapes=makeStartingShapes(board,1,1,0);

dont forget to change output path

==============

# the idea

The input of my system should be a list of starting shapes.
First, my system has a “imagery space”, 
which is a bunch of simple pictures that describe simple concept such as a cat, a face and an apple. 
Then the system will break those pictures into pieces according to their colors or connectedness or some other rules. 
For each of those small pieces, the system will use one or more starting shapes to fit them, 
pick the best fit pattern as the representation of the piece, and record fitting area percentage at the same time. 
Then the system will combine those representations into one picture according to their spatial relationship in original picture and compute overall fitting area percentage. 
After generate all of the pictures, the system will output first five pictures that have higher overall fitting area percentage.
==============

# system design

## in & out
>> input: an array that each entry indicating a starting shape.
>> //sample: [shape1,shape2,shape3,shape4,shape5] (each entry is an object handler)
>> output: an picture that contains starting shapes, which conveys general idea of a concept such as a cat, a face and an apple.

## data structure for shapes
properties: 
>> bin // binary image of the shape
>> category
>> center
>> orientation
>> majorAxisLength
>> minorAxisLength
>> filledArea
>> boundingBox

## operation on shapes
methods:
>> move
>> rotate
>> amplify
>> minify

## data structure for objects in imagery space
>> image	//original image
>> shapelist	//a list of shapes containing in this image(every image has been preprocessed and separated into shapes before AI runs, 
		//info about these shapes is stored in the disk)


## overall design
>> given an input array arrStartingShapes
>> for each object in imagery space
>> 	for each shape A in the shapelist
>> 		for each shape B in arrStartingShapes
>> 			fit shape A using many different size shape B (return coverage area and fittingShapeList)
>> 			record coverage area and fittingShapeList of this shape B
>> 		endfor
>> 		pick one shape B that have maximum coverage area, and the fittingShapeList of this B should be the best fitting of shape A
>>	endfor
>>	combine all best fittings of shape As as the best fitting of the picture, calculate overall coverage area and thus overall coverage percentage
>> endfor
>> pick 5 objects that have highest overall coverage percentage as the system output

## fitting algorithm

fitting solution for known shape:

same shape category:
if the shape category of shape A equal to the shape category of shape B, then shape A itself should be the best fitting solution for it, 
so just duplicate shape A as the best fitting of shape A and return coverage area as the coverage area of shape A.

use circle to fit rectangle:
get the length of the rec;
get the height of the rec;
get the center of the rec;
the first circle in fittingShapeList should be a cicle(center,height/2)
recursively add new circle to fittingShapeList:
	calculate remainingLenth=lenth of rec - curCircleNum*height of rec
	if remainingLenth >height;
		add two circle that center= center of rec +- height*angle

use circle to fit re



coverPersentage->A&B/max(A,B)

