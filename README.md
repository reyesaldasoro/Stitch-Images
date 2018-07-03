# Stitch-Images
Matlab Routines to stitch four images (Quadrants)


<p>
A longer description of the algorithm including intermediate steps can be found in the book:
</p>
<p>
 <a href="http://onlinelibrary.wiley.com/book/10.1002/9781118657546">
  Biomedical image analysis recipes in MATLAB: for life scientists and engineers</a>, <br>
CC Reyes-Aldasoro<br>
John Wiley & Sons.
</p>

 <div class="content"><h1>User Manual for stitch4Images</h1><!--introduction--><!--/introduction-->
<h2>Introduction<a name="1"></a></h2>
<p>In some cases, you might not be able to capture the whole region of
interest using the x2.5 magnification objective of the microscopes. It
is possible to "stitch" four images together in Matlab. For more than 4
images there are commercial software packages that can be downloaded for
free. This manual describes how to stitch 4 images into a single one.</p>
          <h2>Loading the data into Matlab<a name="2"></a></h2>
<p>As always, you need to load the data into matlab, either by using imread or drag-and-drop. Refer to other manuals for more details. In this case, I will load them using imread:</p>
<pre class="codeinput">quadrant1=imread(<span class="string">'Q1.bmp'</span>);
quadrant2=imread(<span class="string">'Q2.bmp'</span>);
quadrant3=imread(<span class="string">'Q3.bmp'</span>);
quadrant4=imread(<span class="string">'Q4.bmp'</span>);

figure(1)
imagesc(quadrant1)
figure(2)
imagesc(quadrant2)
figure(3)
imagesc(quadrant3)
figure(4)
imagesc(quadrant4)
</pre>


![Screenshot](Figures/userManualStitch_01.png)

![Screenshot](Figures/userManualStitch_02.png)

![Screenshot](Figures/userManualStitch_03.png)

![Screenshot](Figures/userManualStitch_04.png)


<p>The order in which the images must be presented to the algorithm is the following: 1 : top - left, 2 : top - right, 3 : bottom - left, 4 : bottom - right.</p>

<h2>Running the algorithm<a name="4"></a></h2>

<p>To obtanined the stitched version of the image simply type:</p><pre class="codeinput">completeImage = stitch4Images(quadrant1,quadrant2,quadrant3,quadrant4);
</pre>

<p>And to visualise it:</p><pre class="codeinput">figure(5)
imagesc(completeImage/255)
</pre>


![Screenshot](Figures/userManualStitch_05.png)

<p>The 255 is used as the output is a "double".</p>

<h2>Saving<a name="7"></a></h2>

<p>To save your image, you can simply click on the "edit" menu from the figure, the go to "copy" and then you can "paste" it in word, powerpoint, ... You can also click on "File" then "Save" and select the name (e.g. "myFabulousImage.jpg") and the format (jpg,tif,bmp,...) you prefer.</p>

<pre class="codeinput"><span class="comment">%or save it as a matlab file in the following way:</span>

save <span class="string">myFabuolusImage</span> <span class="string">completeImage</span>
</pre>

<p>This last file will save the data of "completeImage" inside the file myFabulousImage. You can save more things there, for instance</p><pre class="codeinput">save <span class="string">myFabuolusImage</span> <span class="string">completeImage</span> <span class="string">quadrant1</span> <span class="string">quadrant2</span> <span class="string">quadrant3</span> <span class="string">quadrant4</span>
</pre><p>will save all the quadrants and the results.</p>
