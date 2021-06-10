classdef Figure2Gif < handle
    %����GIF�ļ�
    
    properties
        input_dir   %����ļ���
        extend      %��׺
        fileNames   %�����ļ�
    end
    
    methods
        function obj = Figure2Gif(input_dir_, extend, output_filename)
            switch nargin
                case 3
                    obj.extend =  extend;
                    obj.input_dir = fullfile(input_dir_);
                    %��ȡ�����ļ�
                    fileFolder=obj.input_dir;
                    dirOutput=dir(fullfile(fileFolder,extend));
                    obj.fileNames={dirOutput.name};
                    obj.SortfileNames(); %�ļ�������
                    %����ļ�
                    obj.OutputGif(output_filename);
                case 2
                    obj.extend =  extend;
                    obj.input_dir = fullfile(input_dir_);
                    %��ȡ�����ļ�
                    fileFolder=obj.input_dir;
                    dirOutput=dir(fullfile(fileFolder,extend));
                    obj.fileNames={dirOutput.name};
                    obj.SortfileNames(); %�ļ�������
                otherwise
                    
            end
            
            
        end
        
        function OutputGif(obj,filename)
            %���gif�ļ�
            
            P = cell(size(obj.fileNames,2));
            %��ȡ�ļ�
            for idx = 1:size(obj.fileNames,2)
                filename_temp = fullfile(obj.input_dir,obj.fileNames{idx});
                P(idx) = {imread(filename_temp)}; %rgbͼ���ȡ
            end
            
            %����֡����
            Picture_save = cell(size(obj.fileNames,2));
            for idx = 1:size(obj.fileNames,2)
                figure(idx);
                %����ͼת��Ϊ���ͼ ��{}����������������� ��������Ԫ������
                
                imshow(P{idx});
                ax = gca; %��ǰ������
                
                %��ӽ����ı�
                dim = [ax.Position(1) ax.Position(2)+ax.Position(4) 0.0 0.0];
                str = ['����: ', num2str(idx), ' / ', num2str(size(obj.fileNames,2))];
                t = annotation('textbox',dim,'String',str,'FitBoxToText','on');
                t.Color = 'white'; t.FontSize = 24; 
                t.EdgeColor = 'white';
                
                %��ȡfigure��idx��չʾ��Ч����������ͼƬ���ݱ���
                Picture_save{idx} = frame2im(getframe(ax));
                close all
            end

            %����gif
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
            %���ļ�������������������
            %ֻҪ��һ��û��������ô�Ͳ�����
            
            A = zeros(1,size(obj.fileNames,2)); %��ȡ�ļ����
            for idx = 1:size(obj.fileNames,2)
                %ÿ���ļ���
                
                id_len = 0; %���ֳ���
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
                    return; %ֻҪ��һ��û��������ô�Ͳ�����
                end
                
            end
            
            [~,I] = sort(A);
            obj.fileNames = obj.fileNames(I);
        end
    end
end

