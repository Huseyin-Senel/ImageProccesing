

% directory             =   datasetin bulunduğu klasör
% selectImage           =   datasetten seçilen resim  (1-687)

function SIFT(directory, selectImage)

    imagefiles = dir(directory+'\*.jpg');      
    imageList = {};
    grayImageList = {};
    pointsList = {};
    
    for i=1:length(imagefiles)
        currentfilename = imagefiles(i).name;
        currentimage = imread(directory+'\'+currentfilename);
        imageList{i} = currentimage;
    
        currentimage = rgb2gray(currentimage);
        grayImageList{i} = currentimage;
        points = detectSIFTFeatures(currentimage);
        pointsList{i} = points;
        
    end
    
    
    i=selectImage;
    max = 0;
    newj=0;
    goodMatches = 0;
    badMatches = 0;
    matchCount = 0;
    
    [features1,valid_points1] = extractFeatures(grayImageList{i},pointsList{i});
    
    for j=1:length(imageList)
        if i==j
            continue;
        end


        [features2,valid_points2] = extractFeatures(grayImageList{j},pointsList{j});    %.selectStrongest(100)        
        %[indexPairs,matchmetric] = matchFeatures(features1,features2);   
        [indexPairs,matchmetric] = matchFeatures(features1,features2,"MatchThreshold",100);           
            

            if not(isempty(matchmetric))
    
                %En iyi eşleşen görüntüyü bulma
                summ = length(matchmetric);
                if summ > max
                    max = summ;
                    newj = j;
                    matchCount = length(matchmetric);

                    goodMatches = length(matchmetric(matchmetric < 1));  %Threshold  1
                    badMatches = length(matchmetric)-goodMatches;

    
                    matchedPoints1 = valid_points1(indexPairs(:,1),:);
                    matchedPoints2 = valid_points2(indexPairs(:,2),:);
    
                end
          
            end 
    end
    
    
        figure; 
        ax = axes;
        showMatchedFeatures(imageList{i},imageList{newj},matchedPoints1,matchedPoints2,"montag",Parent=ax);
        msg = sprintf('All Keypoints = %d, Good Matches = %d, Bad Matches = %d',matchCount,goodMatches,badMatches);
        title(ax,msg);
        legend(ax,"Matched points 1","Matched points 2");

        
           
end








