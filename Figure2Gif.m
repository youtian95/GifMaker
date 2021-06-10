classdef Figure2Gif < handle
    %生成GIF文件
    
    properties
        input_dir   %输出文件夹
        extend      %后缀
        fileNames   %所有文件
    end
    
    methods
        function obj = Figure2Gif(input_dir_, extend, output_filename)
            switch nargin
                case 3
                    obj.extend =  extend;
                    obj.input_dir = fullfile(input_dir_);
                    %读取所有文件
                    fileFolder=obj.input_dir;
                    dirOutput=dir(fullfile(fileFolder,extend));
                    obj.fileNames={dirOutput.name};
                    obj.SortfileNames(); %文件名排序
                    %输出文件
                    obj.OutputGif(output_filename);
                case 2
                    obj.extend =  extend;
                    obj.input_dir = fullfile(input_dir_);
                    %读取所有文件
                    fileFolder=obj.input_dir;
                    dirOutput=dir(fullfile(fileFolder,extend));
                    obj.fileNames={dirOutput.name};
                    obj.SortfileNames(); %文件名排序
                otherwise
                    
            end
            
            
        end
        
        function OutputGif(obj,filename)
            %输出gif文件
            
            P = cell(size(obj.fileNames,2));
            %读取文件
            for idx = 1:size(obj.fileNames,2)
                filename_temp = fullfile(obj.input_dir,obj.fileNames{idx});
                P(idx) = {imread(filename_temp)}; %rgb图像获取
            end
            
            %保留帧数据
            Picture_save = cell(size(obj.fileNames,2));
            for idx = 1:size(obj.fileNames,2)
                figure(idx);
                %索引图转换为真彩图 ，{}访问数组里面的类型 （）访问元胞类型
                
                imshow(P{idx});
                ax = gca; %当前坐标区
                
                %添加进度文本
                dim = [ax.Position(1) ax.Position(2)+ax.Position(4) 0.0 0.0];
                str = ['进度: ', num2str(idx), ' / ', num2str(size(obj.fileNames,2))];
                t = annotation('textbox',dim,'String',str,'FitBoxToText','on');
                t.Color = 'white'; t.FontSize = 24; 
                t.EdgeColor = 'white';
                
                %获取figure（idx）展示的效果，将其以图片数据保存
                Picture_save{idx} = frame2im(getframe(ax));
                close all
            end

            %制作gif
            for idx = 1:size(obj.fileNames,2)
                [A,map] = rgb2ind(Picture_save{idx},256);
                if idx == 1
                    imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1);
                else
                    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.2);
                end
            end
        end
    end
    
    methods (Access = private)
        function SortfileNames(obj)
            %将文件名按照最后的数字排序
            %只要有一个没有数字那么就不排序
            
            A = zeros(1,size(obj.fileNames,2)); %提取文件编号
            for idx = 1:size(obj.fileNames,2)
                %每个文件名
                
                id_len = 0; %数字长度
                for i = (strlength(obj.fileNames{idx}) - (strlength(obj.extend)-1)):-1:1
                    if (obj.fileNames{idx}(i) >='0' && obj.fileNames{idx}(i)<='9')
                        id_len = id_len+1;
                    else
                        break;
                    end
                end
                
                if id_len>0
                    temp_char = ...
                        obj.fileNames{idx}(end - (strlength(obj.extend)-1) ...
                        - (id_len-1): ...
                        end - (strlength(obj.extend)-1));
                    A(idx) = str2num(string(temp_char));
                else
                    return; %只要有一个没有数字那么就不排序
                end
                
            end
            
            [~,I] = sort(A);
            obj.fileNames = obj.fileNames(I);
        end
    end
end

