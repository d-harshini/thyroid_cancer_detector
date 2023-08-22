clear;
files1 = dir('*.xml');
files = dir('*.jpg');
numfiles = length(files);

for k = 1:numfiles  
    img = files(k).name 
    xfile=files1(k).name
    str=xml2struct(xfile);
    data=str.case.mark.svg.Text;
    Num = regexp(data,'\d*','Match');
    c=str2double(Num);
    m=1;
    for i=1:length(c)/2
        for j=1:2
            b(i,j)=c(m);
            m=m+1;
        end
    end

    I = imread(img);
    I= rgb2gray(I);
    h = images.roi.Freehand(gca,'Position',b);
    pos = h.Position;
    mask = uint8(h.createMask());
    I2 = I .* mask; % apply mask
    x1 =  round(min(pos(:,2)));
    y1 =  round(min(pos(:,1)));
    x2 =  round(max(pos(:,2)));
    y2 =  round(max(pos(:,1)));
    Icropped = I2(x1:x2, y1:y2, :);
       
    sigma = 1;
    kernelSize=ceil(2.9786*sigma);
    x = -kernelSize:kernelSize;    
    % Compute the Gaussian kernel
    gaussianKernel = exp(- x.^2 / (2*sigma^2) );
    % Normalise kernel
    gaussianKernel = gaussianKernel .* 1/sum(sum(gaussianKernel));    
    % Make a copy of the image variable
    filteredImage = Icropped;    
    % Convolve the image in each direction individually
    for i=1:2
        % We switch direction of the kernel for the second iteration
        if(i==2)
            gaussianKernel = gaussianKernel';
        end        
        filteredImage = imfilter(filteredImage,gaussianKernel,'symmetric','same');
    end
    
    
    
    [pixelCounts,GLs] = imhist(filteredImage);
    [meanGL, sd, skew, kurtosis] = histogram(GLs, pixelCounts);
    hist=[meanGL, sd, skew, kurtosis];
    
    ellipse_t=fit_ellipse_final(b(:,1),b(:,2));
    hl=ellipse_t.long_axis;
    vl=ellipse_t.short_axis;
    ar=hl/vl;
    a=ellipse_t.phi;
    arr=[hl,vl,ar,a];
    
    GLCM2 = graycomatrix(filteredImage);
    stats1 = GLCM_Features1(GLCM2,0);
    stats1=[stats1.autoc,stats1.contr,stats1.energ,stats1.homom,stats1.entro,stats1.cshad,stats1.sosvh,stats1.savgh,stats1.svarh,stats1.senth];
    
    [GLRLM,SI]= grayrlmatrix(filteredImage,'NumLevels',2,'G',[]);
    stats = grayrlprops(GLRLM,{'SRE','LRE','GLN','RLN','RP','LGRE','HGRE','SRLGE','SRHGE','LRLGE','LRHGE'});
    s1=stats(1,:);
    s2=stats(2,:);
    s3=stats(3,:);
    s4=stats(4,:);
    sa=(s1+s2+s3+s4)/4;
    
    %AXIAL
    J=imrotate(filteredImage,-90)
    
    GLsa=0;
    pixelCountsa=0;
    [meanGLa, sda, skewa, kurtosisa] = histogram(GLsa, pixelCountsa);
    hista=[meanGLa, sda, skewa, kurtosisa];
        
    GLCMa = graycomatrix(J);
    statsa = GLCM_Features1(GLCMa,0);
    statsa=[statsa.autoc,statsa.contr,statsa.energ,statsa.homom,statsa.entro,statsa.cshad,statsa.sosvh,statsa.savgh,statsa.svarh,statsa.senth];
    
    [GLRLMa,SIa]= grayrlmatrix(J,'NumLevels',2,'G',[]);
    statsaa = grayrlprops(GLRLMa,{'SRE','LRE','GLN','RLN','RP','LGRE','HGRE','SRLGE','SRHGE','LRLGE','LRHGE'});
    s1a=statsaa(1,:);
    s2a=statsaa(2,:);
    s3a=statsaa(3,:);
    s4a=statsaa(4,:);
    saa=(s1a+s2a+s3a+s4a)/4;
      
    
gray_x=rgb2gray(I);
%size(gray_x);
imshow(gray_x)
bw_x= imbinarize(gray_x,0.095);
imshow(bw_x)
CC=bwconncomp(bw_x); %BW binary image

stats = regionprops(CC, 'all')

Max_diameter=stats.MajorAxisLength;
Min_diameter=stats.MinorAxisLength;
ConvexArea=stats.ConvexArea;



%%MORPHOLIGICAL FEATURES 
%Perimeter
Perimeter=[stats.Perimeter]

% Area
Area=stats.Area

% Circularity 
Circularity=4*Area*pi/(Perimeter(1)).^2

%Aspect Ratio
Aspect_Ratio= Max_diameter/Min_diameter

%Solidity Proportion of the pixels in the convex hull that are also in the region
Solidity=[stats.Solidity]

%Extent  Area divided by the area of the bounding box.
Extent=[stats.Extent]

%convexity

Convexity = [ConvexArea(1)]/Area
stats=[Perimeter(1) Area(1) Solidity(1) Extent(1) Convexity Aspect_Ratio Circularity ]
    xlswrite('C:\Users\harshini\Desktop\Works\sem8\Features.xls', [hist,arr,stats1,sa,hista,statsa,saa,stats1], 'Sheet1', ['A' num2str(k)  ':' 'BB' num2str(k)])    
    
    %normalize
    
    clear b
end