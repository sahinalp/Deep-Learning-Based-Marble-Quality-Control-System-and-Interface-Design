classdef MarbleApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MarbleAppUIFigure           matlab.ui.Figure
        DatePicker                  matlab.ui.control.DatePicker
        ClassifyfromFolderButton    matlab.ui.control.Button
        SingleClassificationButton  matlab.ui.control.Button
        LabelAcc                    matlab.ui.control.Label
        LabelMarbleClass            matlab.ui.control.Label
        TextAreaMarbleAcc           matlab.ui.control.TextArea
        TextAreaMarbleClass         matlab.ui.control.TextArea
        LabelMarbleType             matlab.ui.control.Label
        ClassificationButton        matlab.ui.control.Button
        CrackDetectionButton        matlab.ui.control.Button
        Gobacktomenu                matlab.ui.control.Button
        ImageListListBoxLabel       matlab.ui.control.Label
        OutputImageLabel            matlab.ui.control.Label
        OriginalImageLabel          matlab.ui.control.Label
        Crack_Length                matlab.ui.control.Label
        FindLengthButton            matlab.ui.control.Button
        Label_path                  matlab.ui.control.Label
        Label_selected              matlab.ui.control.Label
        LoadDataButton              matlab.ui.control.Button
        LastImage                   matlab.ui.control.Image
        OriginalImage               matlab.ui.control.Image
        UITable                     matlab.ui.control.Table
        ImageListListBox            matlab.ui.control.ListBox
        Switch_lang                 matlab.ui.control.Switch
        TestDataButton              matlab.ui.control.Button
        UIAxesPie                   matlab.ui.control.UIAxes
        UIAxesOrt                   matlab.ui.control.UIAxes
        UIAxesMarbleType            matlab.ui.control.UIAxes
        UIAxesImage                 matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        net
        NumLabel = 1 ;
        AllLabels
        AllAcc ;
        ClassResult = table ;
        FirstLabel = [];
        Today ;
        NumBB=1 ; NumBE=1 ; NumBG=1 ; NumTC=1 ; NumTN=1 ;
        BB_Acc = [] ; BE_Acc = [] ; BG_Acc = [] ; TC_Acc = [] ; TN_Acc = [] ; 
        CamImg ;
        value = "TR" ;
    end
    
    methods (Access = private)
        function [imdsTest,pxdsTest,net]=imdsTest_pxdsTest(app)
            selectedfile=app.Label_selected.Text;
            path=app.Label_path.Text;
            fprintf(selectedfile);
            S=load(selectedfile);
            
            %imdsTest
            locationOfImages=[path,'datastore\TestImages'];
            imdsTest=dataStoreCreator(locationOfImages,S.TestImages);
            
            %pxdsTest
            locationOfImages=[path,'datastore\TestLabels'];
            pxdsTest=labelStoreCreator(locationOfImages,S.TestLabels,S.classes);
            
            net=S.net;
            
            function ds=dataStoreCreator(loc,data)
            numberOfImages=numel(data);
            locationOfImages=loc+"\";
            inFile=dir(locationOfImages);
            [sizeOfFile,~]=size(inFile);
            if sizeOfFile-2~=numberOfImages
                for i=1:numberOfImages
                    a=data{i};
                    nameLabel=[(int2str(i)),'.png'];
                    fullDestinationFileName= fullfile(loc, nameLabel);
                    imwrite(a,fullDestinationFileName)
                end
            end
            x=fullfile(loc,'\');
            ds=imageDatastore(x);
            end
            function ds=labelStoreCreator(loc,data,classes)
                numberOfImages=numel(data);
                locationOfImages=loc+"\";
                inFile=dir(locationOfImages);
                [sizeOfFile,~]=size(inFile);
                if sizeOfFile-2~=numberOfImages
                    for i=1:numberOfImages
                        a=data{i};
                        a=uint8(a);
                        nameLabel=['Label_',(int2str(i)),'.png'];
                        fullDestinationFileName= fullfile(loc, nameLabel);
                        imwrite(a,fullDestinationFileName)
                    end
                end
                x=fullfile(loc,'\');
                labelIDs = [1 2];
                ds = pixelLabelDatastore(x, classes, labelIDs);
            end
        end
        function [imds,pxds,imdsTrain,pxdsTrain,imdsVal,pxdsVal,imdsTest,pxdsTest,net,classes] = imds_pxds(app)
            selectedfile=app.Label_selected.Text;
            path=app.Label_path.Text;
            fprintf(selectedfile);
            S=load(selectedfile);
            
            folder=fullfile(path,'datastore');
            if ~exist(folder,'file')
                mkdir(folder);
                
                %Images
                folder=fullfile(path,'datastore\','Images');
                mkdir(folder);
                %TrainImages
                folder=fullfile(path,'datastore\','TrainImages');
                mkdir(folder);
                %ValImages
                folder=fullfile(path,'datastore\','ValImages');
                mkdir(folder);
                %TestImages
                folder=fullfile(path,'datastore\','TestImages');
                mkdir(folder);
                
                %Labels
                folder=fullfile(path,'datastore\','Labels');
                mkdir(folder);
                %TrainLabels
                folder=fullfile(path,'datastore\','TrainLabels');
                mkdir(folder);
                %ValLabels
                folder=fullfile(path,'datastore\','ValLabels');
                mkdir(folder);
                %TestLabels
                folder=fullfile(path,'datastore\','TestLabels');
                mkdir(folder);
            end
            %imds
            locationOfImages=[path,'datastore\Images'];
            imds=dataStoreCreator(locationOfImages,S.Images);
            %imdsTrain
            locationOfImages=[path,'datastore\TrainImages'];
            imdsTrain=dataStoreCreator(locationOfImages,S.TrainImages);
            %imdsVal
            locationOfImages=[path,'datastore\ValImages'];
            imdsVal=dataStoreCreator(locationOfImages,S.ValImages);
            %imdsTest
            locationOfImages=[path,'datastore\TestImages'];
            imdsTest=dataStoreCreator(locationOfImages,S.TestImages);
            
            %pxds
            locationOfImages=[path,'datastore\Labels'];
            pxds=labelStoreCreator(locationOfImages,S.Labels,S.classes);
            %pxdsTrain
            locationOfImages=[path,'datastore\TrainLabels'];
            pxdsTrain=labelStoreCreator(locationOfImages,S.TrainLabels,S.classes);
            %pxdsVal
            locationOfImages=[path,'datastore\ValLabels'];
            pxdsVal=labelStoreCreator(locationOfImages,S.ValLabels,S.classes);
            %pxdsTest
            locationOfImages=[path,'datastore\TestLabels'];
            pxdsTest=labelStoreCreator(locationOfImages,S.TestLabels,S.classes);
            
            net=S.net;
            classes=S.classes;
            
            
            function ds=dataStoreCreator(loc,data)
            numberOfImages=numel(data);
            locationOfImages=loc+"\";
            inFile=dir(locationOfImages);
            [sizeOfFile,~]=size(inFile);
            if sizeOfFile-2~=numberOfImages
                for i=1:numberOfImages
                    a=data{i};
                    nameLabel=[(int2str(i)),'.png'];
                    fullDestinationFileName= fullfile(loc, nameLabel);
                    imwrite(a,fullDestinationFileName)
                end
            end
            x=fullfile(loc,'\');
            ds=imageDatastore(x);
            end
            function ds=labelStoreCreator(loc,data,classes)
                numberOfImages=numel(data);
                locationOfImages=loc+"\";
                inFile=dir(locationOfImages);
                [sizeOfFile,~]=size(inFile);
                if sizeOfFile-2~=numberOfImages
                    for i=1:numberOfImages
                        a=data{i};
                        a=uint8(a);
                        nameLabel=['Label_',(int2str(i)),'.png'];
                        fullDestinationFileName= fullfile(loc, nameLabel);
                        imwrite(a,fullDestinationFileName)
                    end
                end
                x=fullfile(loc,'\');
                labelIDs = [1 2];
                ds = pixelLabelDatastore(x, classes, labelIDs);
            end
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
            %Show Today in DatePicker
            app.DatePicker.Value = datetime('today');
            
            
            %Load Model
            app.net = load('data\model.mat');
            
            
            %Create New Folder for classification
            %Labels Names
            LabelNames = app.net.netTransfer.Layers(25, 1).Classes ;
            
            %Define Today Date
            app.Today = datetime('today','Format','dd-MM-yyyy') ;
            
            %Create New Class Folders
            for m=1:length(LabelNames);
                
                filename = sprintf('%s/%s',app.Today,LabelNames(m));
                mkdir(filename) ;
            end
        end

        % Button pushed function: TestDataButton
        function TestDataButtonPushed(app, event)
            [imds,pxds,imdsTrain,pxdsTrain,imdsVal,pxdsVal,imdsTest,pxdsTest,net,classes] = imds_pxds(app);
            pxdsPred = semanticseg(imdsTest,net,'MiniBatchSize',32,'WriteLocation',tempdir);
            metrics = evaluateSemanticSegmentation(pxdsPred,pxdsTest);
            A=metrics.ImageMetrics;
            A=table2array(A);
            B(:,2:6)=A(:,1:5);
            
            %visible setttings
            app.OutputImageLabel.Visible=1;
            app.OriginalImageLabel.Visible=1;
            app.OriginalImage.Visible=1;
            app.LastImage.Visible=1;
            app.ImageListListBox.Visible=1;
            app.ImageListListBoxLabel.Visible=1;
            app.UITable.Visible=1;
            
            
            
            B=array2table(B,'VariableNames',{'Image','Global Accuracy','Mean Accuracy','Mean IoU','Weighted IoU','Mean BF Score'});
            name=[];
            cmap = color_map();
            for k=1:length(imdsTest.Files)
                B.Image(k)=k;
                if app.Switch_lang.Value=="Eng"
                    name{end+1}="Image "+int2str(k);
                else
                    name{end+1}="Görüntü "+int2str(k);
                end
                
                I=readimage(imdsTest,k);
                C = semanticseg(I, net);
                %Actual
                A = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.7);
                
                expectedResult = readimage(pxdsTest,k);
                actual = uint8(C);
                expected = uint8(expectedResult);
                
                
                app.LastImage.ImageSource=A;
                app.OriginalImage.ImageSource=I;
                
                app.ImageListListBox.Items(end+1)={convertStringsToChars(name{k})};
                app.UITable.Data(end+1,:)=B{k,:};
%                 set(app.ImageListListBox,'Value',int2str(k));
                pause(1)
            end
            
            %visible settings
            app.TestDataButton.Visible=1;
            app.FindLengthButton.Visible=1;
            
            function pixelLabelColorbar(cmap, classNames)
                % Add a colorbar to the current axis. The colorbar is formatted
                % to display the class names with the color.
                
                colormap(gca,cmap)
                
                % Add colorbar to current figure.
                c = colorbar('peer', gca);
                
                % Use class names for tick marks.
                c.TickLabels = classNames;
                numClasses = size(cmap,1);
                
                % Center tick labels.
                c.Ticks = 1/(numClasses*2):1/numClasses:1;
                
                % Remove tick mark.
                c.TickLength = 0;
            end
            function cmap = color_map()
                % Define the colormap used by CamVid dataset.
                
                cmap = [
                    255 0 0          % Crack
                    125 125 125            % Non Crack
                    ];
                
                % cmap = [
                %     0 0 128       % Crack
                %     128 0 0       % Non Crack
                %     ];
                % Normalize between [0 1].
                cmap = cmap ./ 255;
            end
        end

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            [file,path]=uigetfile({'*.mat'}, 'Select info file');
            selectedfile = fullfile(path,file);
%             S=load(selectedfile);
            app.Label_selected.Text=selectedfile;
            app.Label_path.Text=path;
            
            app.TestDataButton.Visible=1;
            
        end

        % Value changed function: ImageListListBox
        function ImageListListBoxValueChanged(app, event)
            value = app.ImageListListBox.Value;
            len=length(value);
            if app.Switch_lang.Value=="Eng"
                k=value(7:end);
            else
                k=value(9:end);    
            end
            
            k=convertCharsToStrings(k);
            k=str2num(k);
            [imds,pxds,imdsTrain,pxdsTrain,imdsVal,pxdsVal,imdsTest,pxdsTest,net,classes] = imds_pxds(app);
            cmap = color_map();
            I=readimage(imdsTest,k);
            C = semanticseg(I, net);
            %Actual
            A = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.7);
            
            expectedResult = readimage(pxdsTest,k);
            actual = uint8(C);
            expected = uint8(expectedResult);
            
            
            %Expected
            B = labeloverlay(I,expected,'ColorMap',cmap);
            
            app.LastImage.ImageSource=A;
            app.OriginalImage.ImageSource=I;
            
            function pixelLabelColorbar(cmap, classNames)
                % Add a colorbar to the current axis. The colorbar is formatted
                % to display the class names with the color.
                
                colormap(gca,cmap)
                
                % Add colorbar to current figure.
                c = colorbar('peer', gca);
                
                % Use class names for tick marks.
                c.TickLabels = classNames;
                numClasses = size(cmap,1);
                
                % Center tick labels.
                c.Ticks = 1/(numClasses*2):1/numClasses:1;
                
                % Remove tick mark.
                c.TickLength = 0;
            end
            function cmap = color_map()
                % Define the colormap used by CamVid dataset.
                
                cmap = [
                    255 0 0          % Crack
                    125 125 125            % Non Crack
                    ];
                
                % cmap = [
                %     0 0 128       % Crack
                %     128 0 0       % Non Crack
                %     ];
                % Normalize between [0 1].
                cmap = cmap ./ 255;
            end
        end

        % Button pushed function: FindLengthButton
        function FindLengthButtonPushed(app, event)
            A=app.LastImage.ImageSource;
            imshow(A)
            hold on
            [x,y]=ginput(2);
            close all
            x1=round(x(1));
            x2=round(x(2));
            y1=round(y(1));
            y2=round(y(2));
            imshow(A)
            hold on
            plot(x,y,'y')
            lenOfCrack=sqrt(((x1-x2)^2)+((y1-y2)^2));
%             realLenOfCrack=lenOfCrack*str2num(pixInfo);

%             app.Crack_Length.Text=message;
            if app.Switch_lang.Value=="Eng"
                message=sprintf('The crack is %.2f pixels',lenOfCrack);
                uiwait(msgbox(message, 'Information'));
            else
                message=sprintf('Kırık %.2f pikselden oluşuyor',lenOfCrack);
                uiwait(msgbox(message, 'Bilgi'));
            end

            
            close all
        end

        % Value changed function: Switch_lang
        function Switch_langValueChanged(app, event)
            value = app.Switch_lang.Value;
            if value=="Eng"
                app.MarbleAppUIFigure.Name="Marble App";
                app.ImageListListBoxLabel.Text="Image List";
                app.UITable.ColumnName=["Image","Global Accuracy","Mean Accuracy","Mean IoU","Weighted IoU","Mean BF Score"];
                app.LoadDataButton.Text="Load Data";
                app.FindLengthButton.Text="Find Length";
                app.TestDataButton.Text="Test Data";
                app.OriginalImageLabel.Text="Original Image";
                app.OutputImageLabel.Text="Output Image";
                app.ClassificationButton.Text="Classification";
                app.CrackDetectionButton.Text="Crack Detection";
                app.Gobacktomenu.Text="Go back to menu";
                
                app.LabelMarbleClass.Text="Marble Classes";
                app.LabelAcc.Text="Percent";
                app.SingleClassificationButton.Text="Single Classification";
                app.ClassifyfromFolderButton.Text="Classify from Folder";
                xlabel(app.UIAxesMarbleType, 'Marble Labels')
                ylabel(app.UIAxesMarbleType, 'Number of Marble')
                xlabel(app.UIAxesOrt, 'Average Classification Percentage')
            else
                app.MarbleAppUIFigure.Name="Mermer Uygulaması";
                app.ImageListListBoxLabel.Text="Görüntü Listesi";
                app.UITable.ColumnName=["Görüntü","Global Doğruluk","Ort. Doğruluk","Ort. IoU","Ağırlıklı IoU","Ort. BF Skoru"];
                app.LoadDataButton.Text="Veri Yükle";
%                 app.LoadDataButton.Text="Görüntü Yükle";
                app.FindLengthButton.Text="Uzunluğu bul";
                app.TestDataButton.Text="Veriyi Test Et";
                app.OriginalImageLabel.Text="Orijinal Görüntü";
                app.OutputImageLabel.Text="Çıktı Görüntüsü";
                app.ClassificationButton.Text="Sınıflandırma";
                app.CrackDetectionButton.Text="Kırık tespiti";
                app.Gobacktomenu.Text="Menüye geri dön";
                
                app.LabelMarbleClass.Text="Mermer Sınıfları";
                app.LabelAcc.Text="Yüzde";
                app.SingleClassificationButton.Text="Tekli Sınıflandır";
                app.ClassifyfromFolderButton.Text="Klasörden Sınıflandır";
                xlabel(app.UIAxesMarbleType, 'Mermer Türleri')
                ylabel(app.UIAxesMarbleType, 'Mermer Adeti')
                xlabel(app.UIAxesOrt, 'Ortalama Sınıflandırma Yüzdesi')
            end
            if ~isempty(app.ImageListListBox.Items)
                [imdsTest,~,~]=imdsTest_pxdsTest(app);
                name=[];
                name_ch=[];
                for k=1:length(imdsTest.Files)
                    if app.Switch_lang.Value=="Eng"
                        name{end+1}="Image "+int2str(k);
                    else
                        name{end+1}="Görüntü "+int2str(k);
                    end
                    if k==1
                        name_ch={convertStringsToChars(name{1})};
                    else
                        name_ch(end+1)={convertStringsToChars(name{k})};
                    end
                end
                app.ImageListListBox.Items(:)=name_ch(:);
            end
        end

        % Button pushed function: Gobacktomenu
        function GobacktomenuButtonPushed(app, event)
            %visible setttings(crack detection)
            app.OutputImageLabel.Visible=0;
            app.OriginalImageLabel.Visible=0;
            app.OriginalImage.Visible=0;
            app.LastImage.Visible=0;
            app.ImageListListBox.Visible=0;
            app.ImageListListBoxLabel.Visible=0;
            app.UITable.Visible=0;
            
            app.TestDataButton.Visible=0;
            app.FindLengthButton.Visible=0;
            app.LoadDataButton.Visible=0;
            
            %visible setttings(classification)
            app.SingleClassificationButton.Visible=0;
            app.ClassifyfromFolderButton.Visible=0;
            app.DatePicker.Visible=0;
            
            app.UIAxesImage.Visible=0;
            app.UIAxesMarbleType.Visible=0;
            app.UIAxesOrt.Visible=0;
            app.UIAxesPie.Visible=0;
            
            app.UIAxesImage.Position=[0,0,0,0];
            app.UIAxesMarbleType.Position=[0,0,0,0];
            app.UIAxesOrt.Position=[0,0,0,0];
            app.UIAxesPie.Position=[0,0,0,0];
            
            app.LabelAcc.Visible=0;
            app.LabelMarbleClass.Visible=0;
            app.TextAreaMarbleAcc.Visible=0;
            app.TextAreaMarbleClass.Visible=0;
            app.LabelMarbleType.Visible=0;
            
            legend(app.UIAxesPie,'Position',[110 110 0 0])
            
            
            app.Gobacktomenu.Visible=0;
            app.ClassificationButton.Visible=1;
            app.CrackDetectionButton.Visible=1;
            
            
            
        end

        % Button pushed function: CrackDetectionButton
        function CrackDetectionButtonPushed(app, event)
            app.Gobacktomenu.Visible=1;
            app.CrackDetectionButton.Visible=0;
            app.ClassificationButton.Visible=0;
            
            app.LoadDataButton.Visible=1;
        end

        % Button pushed function: ClassificationButton
        function ClassificationButtonPushed(app, event)
            app.Gobacktomenu.Visible=1;
            app.CrackDetectionButton.Visible=0;
            app.ClassificationButton.Visible=0;
            
            app.SingleClassificationButton.Visible=1;
            app.ClassifyfromFolderButton.Visible=1;
            app.DatePicker.Visible=1;
                        
        end

        % Callback function
        function SelectImageButtonPushed(app, event)
            [path,file]=uigetfile({'*.jpg; *.bmp;*.gif;*.tiff;*.Tiff;*.Tif;*.tiff;*.jfif;*.jpeg;*.png'}, 'Select file');
            Picture=[file path];
            OrginalPic=imread(Picture);
             
       
             OrginalPic = imresize(  OrginalPic ,  [app.sz(1),app.sz(2)]) ;
%              imshow(OrginalPic,'Parent',app.UIAxes4);
            app.ClassificationImage.ImageSource=OrginalPic;
            
            [label,score] = classify(app.net.netTransfer, OrginalPic);
            
            app.AccuracyLabel.Visible=1;
            app.ClassLabel.Visible=1;
            app.ClassificationImage.Visible=1;
            
            app.ClassLabel.Text = char(label);
            value = app.Switch_lang.Value;
            if value=="Eng"
                app.AccuracyLabel.Text =[num2str(max(score)*100),' %'];
            else
                app.AccuracyLabel.Text =['% ',num2str(max(score)*100)];
            end
            
        end

        % Button pushed function: SingleClassificationButton
        function SingleClassificationButtonPushed(app, event)
            %Load Image
            [path,file]= uigetfile({'*.jpg; *.bmp;*.gif;*.tiff;*.Tiff;*.Tif;*.tiff;*.jfif;*.jpeg;*.png'}, 'Select file');
            Picture    = [file path];
            OrginalPic = imread(Picture);
            
            %visible settings
            app.UIAxesImage.Visible=1;
            app.UIAxesPie.Visible=1;
            
            app.UIAxesImage.Position=[26,359,360,296];
            app.UIAxesPie.Position=[357,350,477,273];
            
            app.LabelAcc.Visible=1;
            app.LabelMarbleClass.Visible=1;
            app.TextAreaMarbleAcc.Visible=1;
            app.TextAreaMarbleClass.Visible=1;
            app.LabelMarbleType.Visible=1;
            
            
            
            
            %Show Image
            OrginalPic = imresize(OrginalPic ,[227,227]) ;
            imshow(OrginalPic,'Parent',app.UIAxesImage);
            
            
            
            %Find Label and Accuracy
            [label,score] = classify(app.net.netTransfer, OrginalPic);
            
            %Show Label of Marble
            app.LabelMarbleType.Text = char(label);
            
            labels = {'BEIGE-BLUEDARK','BEIGE-EMP','BEIGE-GRI','TRV-CLASSIC','TRV-NOCE'};   
            scorePer = (score)*100 ;
            explode  = [1,1,1,1,1];
            pie3(app.UIAxesPie,double(scorePer))
            legend(app.UIAxesPie,labels,'Position',[0.85 0.8 0.1 0.2])
            
            
            %Create Labels Cell and Print
            app.AllLabels{app.NumLabel} = char(label); 
            app.TextAreaMarbleClass.Value          = fliplr(app.AllLabels);
            
            
            %Create Accuracy Cell and Print
            app.AllAcc{app.NumLabel} = num2str(max(score)*100,'%.2f') ;
            app.TextAreaMarbleAcc.Value     = fliplr(app.AllAcc);
            
            %Save images
            Images{app.NumLabel} = OrginalPic ;

            %Increase Order of Data
            app.NumLabel = app.NumLabel + 1 ;
        end

        % Button pushed function: ClassifyfromFolderButton
        function ClassifyfromFolderButtonPushed(app, event)
            digitDatasetPath = fullfile(uigetdir);
            imds = imageDatastore(digitDatasetPath,'IncludeSubfolders',true) ;
            
            %visible Settings
            app.UIAxesImage.Visible=1;
            app.UIAxesMarbleType.Visible=1;
            app.UIAxesOrt.Visible=1;
            app.UIAxesPie.Visible=1;
            
            app.UIAxesImage.Position=[26,359,360,296];
            app.UIAxesMarbleType.Position=[289,185,396,207];
            app.UIAxesOrt.Position=[273,11,454,196];
            app.UIAxesPie.Position=[357,350,477,273];
            
            app.LabelAcc.Visible=1;
            app.LabelMarbleClass.Visible=1;
            app.TextAreaMarbleAcc.Visible=1;
            app.TextAreaMarbleClass.Visible=1;
            app.LabelMarbleType.Visible=1;
            
            
            for i=1:length(imds.Files)
                
                OrginalPic = imread(imds.Files{i}) ;
                ResizedPic = imresize(OrginalPic ,[227,227]) ;
                imshow(ResizedPic,'Parent',app.UIAxesImage);
                
                
                %Find Label and Accuracy
                [label,score] = classify(app.net.netTransfer, ResizedPic);
                
                app.LabelMarbleType.Text = char(label);
                
                %Define Current H/M/S/MS
                CurrentTime = datetime('now','Format','HH.mm.ss.SSS') ;
                
                %Save Image to Related Folder
                ImageName = sprintf('%s/%s/%s.jpg',app.Today,label,CurrentTime) ;
                imwrite(OrginalPic,ImageName) ;

                %Plot Pie Chart
                labels = categorical({'BEIGE-BLUEDARK','BEIGE-EMP','BEIGE-GRI','TRV-CLASSIC','TRV-NOCE'});
                scorePer = (score)*100 ;
                explode  = [1,1,1,1,1];
                pie3(app.UIAxesPie,double(scorePer),explode)
                legend(app.UIAxesPie,labels,'Position',[0.85 0.8 0.1 0.2])
                
                %Create Labels Cell and Print     
                app.AllLabels{app.NumLabel} = char(label)
                app.TextAreaMarbleClass.Value          = fliplr(app.AllLabels);
                
                %Plot Histogram
                HistogramLabels(app.NumLabel) = label ;
                h = histogram(app.UIAxesMarbleType,HistogramLabels);
                h.DisplayOrder = 'descend';
                h.BarWidth = 0.63 ;
  
                
                %Create Accuracy Cell and Print
                app.AllAcc{app.NumLabel} = num2str(max(score)*100,'%.2f') ;
                app.TextAreaMarbleAcc.Value     = fliplr(app.AllAcc);
                
                
                %Create Accuracy matrix for each class               
                if label == "BEIGE-BLUE DARK"
                    app.BB_Acc(app.NumBB) = max(score)*100 ;
                    app.NumBB=app.NumBB+1   
                elseif label == "BEIGE-EMP"
                    app.BE_Acc(app.NumBE) = max(score)*100 ;
                    app.NumBE = app.NumBE+1      
                elseif label == "BEIGE-GRI"
                    app.BG_Acc(app.NumBG) = max(score)*100 ;
                    app.NumBG = app.NumBG+1
                elseif label == "TRV-CLASSIC VS"
                    app.TC_Acc(app.NumTC) = max(score)*100 ;
                    app.NumTC = app.NumTC+1
                elseif label == "TRV-NOCE"
                    app.TN_Acc(app.NumTN) = max(score)*100 ;
                    app.NumTN = app.NumTN+1
                end
                
                AccMeans = [mean(app.BB_Acc), mean(app.BE_Acc), mean(app.BG_Acc), mean(app.TC_Acc), mean(app.TN_Acc)] ;
                
                %Bar Graph For Mean Accuracy
                b = barh(app.UIAxesOrt,labels,AccMeans)
                b.BarWidth = 0.5 ; 
                b.FaceColor = 'flat' ;
                b.CData(1,:) = [0.1373 0.1882 0.5294];
                b.CData(2,:) = [0.0353 0.5725 0.9294];
                b.CData(3,:) = [0.0745 0.6941 0.7412];
                b.CData(4,:) = [0.7098 0.6118 0.2118];
                b.CData(5,:) = [1 1 0];
                
                
                
                %Increase Order of Data
                app.NumLabel = app.NumLabel + 1 ;
                
                pause(0.5)
            end
        end

        % Value changed function: TextAreaMarbleClass
        function TextAreaMarbleClassValueChanged(app, event)
            value = app.TextAreaMarbleClass.Value;
        end

        % Value changed function: DatePicker
        function DatePickerValueChanged(app, event)
            value = app.DatePicker.Value ;
            
            if 7==exist(string(value),'dir')
                winopen(string(value))
            else
                if app.value == "ENG"
                hataMesaji = sprintf("No Classification Made on %s.",string(value))
                msgbox(hataMesaji, 'Error','error');                      
                else
                hataMesaji = sprintf("%s Tarihinde Sınıflandırma Yapılmamış.",string(value))
                msgbox(hataMesaji, 'Error','error');
                end
            end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MarbleAppUIFigure and hide until all components are created
            app.MarbleAppUIFigure = uifigure('Visible', 'off');
            app.MarbleAppUIFigure.Position = [100 100 861 659];
            app.MarbleAppUIFigure.Name = 'Marble App';

            % Create UIAxesImage
            app.UIAxesImage = uiaxes(app.MarbleAppUIFigure);
            app.UIAxesImage.PlotBoxAspectRatio = [1.25076452599388 1 1];
            app.UIAxesImage.Visible = 'off';
            app.UIAxesImage.Position = [26 359 360 296];

            % Create UIAxesMarbleType
            app.UIAxesMarbleType = uiaxes(app.MarbleAppUIFigure);
            xlabel(app.UIAxesMarbleType, 'Marble Labels')
            ylabel(app.UIAxesMarbleType, {'Number of Marble'; ''})
            app.UIAxesMarbleType.PlotBoxAspectRatio = [3.61904761904762 1 1];
            app.UIAxesMarbleType.Visible = 'off';
            app.UIAxesMarbleType.Position = [289 185 396 207];

            % Create UIAxesOrt
            app.UIAxesOrt = uiaxes(app.MarbleAppUIFigure);
            xlabel(app.UIAxesOrt, 'Average Classification Percentage')
            app.UIAxesOrt.PlotBoxAspectRatio = [3.61904761904762 1 1];
            app.UIAxesOrt.Visible = 'off';
            app.UIAxesOrt.Position = [273 11 454 196];

            % Create UIAxesPie
            app.UIAxesPie = uiaxes(app.MarbleAppUIFigure);
            app.UIAxesPie.PlotBoxAspectRatio = [1.25076452599388 1 1];
            app.UIAxesPie.YLim = [0 1];
            app.UIAxesPie.XTick = [0 0.2 0.4 0.6 0.8 1];
            app.UIAxesPie.Visible = 'off';
            app.UIAxesPie.Position = [357 350 477 273];

            % Create TestDataButton
            app.TestDataButton = uibutton(app.MarbleAppUIFigure, 'push');
            app.TestDataButton.ButtonPushedFcn = createCallbackFcn(app, @TestDataButtonPushed, true);
            app.TestDataButton.Visible = 'off';
            app.TestDataButton.Position = [691 197 100 22];
            app.TestDataButton.Text = 'Test Data';

            % Create Switch_lang
            app.Switch_lang = uiswitch(app.MarbleAppUIFigure, 'slider');
            app.Switch_lang.Items = {'Eng', 'Tr'};
            app.Switch_lang.ValueChangedFcn = createCallbackFcn(app, @Switch_langValueChanged, true);
            app.Switch_lang.Position = [786 45 45 20];
            app.Switch_lang.Value = 'Eng';

            % Create ImageListListBox
            app.ImageListListBox = uilistbox(app.MarbleAppUIFigure);
            app.ImageListListBox.Items = {};
            app.ImageListListBox.ValueChangedFcn = createCallbackFcn(app, @ImageListListBoxValueChanged, true);
            app.ImageListListBox.Visible = 'off';
            app.ImageListListBox.Position = [11 338 100 276];
            app.ImageListListBox.Value = {};

            % Create UITable
            app.UITable = uitable(app.MarbleAppUIFigure);
            app.UITable.ColumnName = {'Image'; 'Global Accuracy'; 'Mean Accuracy'; 'Mean IoU'; 'Weighted IoU'; 'Mean BF Score'};
            app.UITable.ColumnWidth = {75, 'auto', 'auto', 'auto', 'auto', 'auto'};
            app.UITable.RowName = {};
            app.UITable.Visible = 'off';
            app.UITable.Position = [1 1 592 300];

            % Create OriginalImage
            app.OriginalImage = uiimage(app.MarbleAppUIFigure);
            app.OriginalImage.Visible = 'off';
            app.OriginalImage.Position = [146 324 293 296];

            % Create LastImage
            app.LastImage = uiimage(app.MarbleAppUIFigure);
            app.LastImage.Visible = 'off';
            app.LastImage.Position = [531 324 293 296];

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.MarbleAppUIFigure, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.Visible = 'off';
            app.LoadDataButton.Position = [690 226 100 22];
            app.LoadDataButton.Text = 'Load Data';

            % Create Label_selected
            app.Label_selected = uilabel(app.MarbleAppUIFigure);
            app.Label_selected.Enable = 'off';
            app.Label_selected.Visible = 'off';
            app.Label_selected.Position = [525 129 16 22];

            % Create Label_path
            app.Label_path = uilabel(app.MarbleAppUIFigure);
            app.Label_path.Enable = 'off';
            app.Label_path.Visible = 'off';
            app.Label_path.Position = [526 108 10 22];
            app.Label_path.Text = 'Label2';

            % Create FindLengthButton
            app.FindLengthButton = uibutton(app.MarbleAppUIFigure, 'push');
            app.FindLengthButton.ButtonPushedFcn = createCallbackFcn(app, @FindLengthButtonPushed, true);
            app.FindLengthButton.Visible = 'off';
            app.FindLengthButton.Position = [691 164 100 22];
            app.FindLengthButton.Text = 'Find Length';

            % Create Crack_Length
            app.Crack_Length = uilabel(app.MarbleAppUIFigure);
            app.Crack_Length.Position = [545 317 102 22];
            app.Crack_Length.Text = '';

            % Create OriginalImageLabel
            app.OriginalImageLabel = uilabel(app.MarbleAppUIFigure);
            app.OriginalImageLabel.HorizontalAlignment = 'center';
            app.OriginalImageLabel.Visible = 'off';
            app.OriginalImageLabel.Position = [231 627 106 22];
            app.OriginalImageLabel.Text = 'Original Image';

            % Create OutputImageLabel
            app.OutputImageLabel = uilabel(app.MarbleAppUIFigure);
            app.OutputImageLabel.HorizontalAlignment = 'center';
            app.OutputImageLabel.Visible = 'off';
            app.OutputImageLabel.Position = [628 627 106 22];
            app.OutputImageLabel.Text = 'Output Image';

            % Create ImageListListBoxLabel
            app.ImageListListBoxLabel = uilabel(app.MarbleAppUIFigure);
            app.ImageListListBoxLabel.HorizontalAlignment = 'center';
            app.ImageListListBoxLabel.Visible = 'off';
            app.ImageListListBoxLabel.Position = [11 622 101 27];
            app.ImageListListBoxLabel.Text = 'Image List';

            % Create Gobacktomenu
            app.Gobacktomenu = uibutton(app.MarbleAppUIFigure, 'push');
            app.Gobacktomenu.ButtonPushedFcn = createCallbackFcn(app, @GobacktomenuButtonPushed, true);
            app.Gobacktomenu.Visible = 'off';
            app.Gobacktomenu.Position = [738 11 107 22];
            app.Gobacktomenu.Text = 'Go back to menu';

            % Create CrackDetectionButton
            app.CrackDetectionButton = uibutton(app.MarbleAppUIFigure, 'push');
            app.CrackDetectionButton.ButtonPushedFcn = createCallbackFcn(app, @CrackDetectionButtonPushed, true);
            app.CrackDetectionButton.Position = [357 339 150 46];
            app.CrackDetectionButton.Text = 'Crack Detection';

            % Create ClassificationButton
            app.ClassificationButton = uibutton(app.MarbleAppUIFigure, 'push');
            app.ClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @ClassificationButtonPushed, true);
            app.ClassificationButton.Position = [357 255 150 46];
            app.ClassificationButton.Text = 'Classification';

            % Create LabelMarbleType
            app.LabelMarbleType = uilabel(app.MarbleAppUIFigure);
            app.LabelMarbleType.HorizontalAlignment = 'center';
            app.LabelMarbleType.FontSize = 20;
            app.LabelMarbleType.Visible = 'off';
            app.LabelMarbleType.Position = [458 625 281 33];
            app.LabelMarbleType.Text = 'MERMER TÜRÜ';

            % Create TextAreaMarbleClass
            app.TextAreaMarbleClass = uitextarea(app.MarbleAppUIFigure);
            app.TextAreaMarbleClass.ValueChangedFcn = createCallbackFcn(app, @TextAreaMarbleClassValueChanged, true);
            app.TextAreaMarbleClass.Visible = 'off';
            app.TextAreaMarbleClass.Position = [26 1 157 321];

            % Create TextAreaMarbleAcc
            app.TextAreaMarbleAcc = uitextarea(app.MarbleAppUIFigure);
            app.TextAreaMarbleAcc.Visible = 'off';
            app.TextAreaMarbleAcc.Position = [197 1 67 321];

            % Create LabelMarbleClass
            app.LabelMarbleClass = uilabel(app.MarbleAppUIFigure);
            app.LabelMarbleClass.BackgroundColor = [0.8 0.8 0.8];
            app.LabelMarbleClass.HorizontalAlignment = 'center';
            app.LabelMarbleClass.Visible = 'off';
            app.LabelMarbleClass.Position = [27 332 156 22];
            app.LabelMarbleClass.Text = 'Marble Classes';

            % Create LabelAcc
            app.LabelAcc = uilabel(app.MarbleAppUIFigure);
            app.LabelAcc.BackgroundColor = [0.8 0.8 0.8];
            app.LabelAcc.HorizontalAlignment = 'center';
            app.LabelAcc.Visible = 'off';
            app.LabelAcc.Position = [197 332 67 22];
            app.LabelAcc.Text = 'Percent';

            % Create SingleClassificationButton
            app.SingleClassificationButton = uibutton(app.MarbleAppUIFigure, 'push');
            app.SingleClassificationButton.ButtonPushedFcn = createCallbackFcn(app, @SingleClassificationButtonPushed, true);
            app.SingleClassificationButton.Visible = 'off';
            app.SingleClassificationButton.Position = [699 275 128 26];
            app.SingleClassificationButton.Text = 'Single Classification';

            % Create ClassifyfromFolderButton
            app.ClassifyfromFolderButton = uibutton(app.MarbleAppUIFigure, 'push');
            app.ClassifyfromFolderButton.ButtonPushedFcn = createCallbackFcn(app, @ClassifyfromFolderButtonPushed, true);
            app.ClassifyfromFolderButton.Visible = 'off';
            app.ClassifyfromFolderButton.Position = [699 239 128 26];
            app.ClassifyfromFolderButton.Text = 'Classify from Folder';

            % Create DatePicker
            app.DatePicker = uidatepicker(app.MarbleAppUIFigure);
            app.DatePicker.DisplayFormat = 'dd-MM-uuuu';
            app.DatePicker.ValueChangedFcn = createCallbackFcn(app, @DatePickerValueChanged, true);
            app.DatePicker.Visible = 'off';
            app.DatePicker.Position = [730 87 115 22];
            app.DatePicker.Value = datetime([2021 1 19]);

            % Show the figure after all components are created
            app.MarbleAppUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MarbleApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MarbleAppUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MarbleAppUIFigure)
        end
    end
end