function Model = Read_KM_From_Optistruct_Fast(filName)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ## Description
%    Read the stiffness and mass matrix output by Optistruct
% ## Syntax
%    ```
%    Model = Read_KM_From_Optistruct_Fast(filName)
%    ```
% ## Input
%    - filName: the file path of .full.mat
% ## Input
%    - Model: a structure include K M
% ## Note
%    Ref: https://www.yuque.com/xdd1997/ek3kug/xmmw08php2yi79yr                
%    PWD: cawk                                                                 
%    update:2024-12-5        
% ## End
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(filName,'r');
TEXT00 = textscan(fid,'%s','Delimiter','\n','whitespace','');
fclose(fid);
TEXT = strjoin(TEXT00{1},'');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K_Ben = strfind(TEXT, 'STIF');
M_Ben = strfind(TEXT, 'MASS');
DOF_Ben = strfind(TEXT, 'DOFS');

if isempty(M_Ben)
    K_TEXT = TEXT(K_Ben:(DOF_Ben-1));
    M_TEXT = [];
else
    K_TEXT = TEXT(K_Ben:(M_Ben-1));
    M_TEXT = TEXT(M_Ben:(DOF_Ben-1));
end
DOF_TEXT = TEXT(DOF_Ben:length(TEXT));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% K
MatrixText = K_TEXT;
fprintf(string(datetime('now'))+":Read Stif ...\n")
tmp = textscan(MatrixText(1,:),'%s%d%d%d%d%d%s');
NCOL = tmp{5};
NROW = tmp{6};
N_Text = length(MatrixText);

POS = 84;
numNonZeroBig = 20;
II = zeros(numNonZeroBig,1);
JJ = zeros(numNonZeroBig,1);
VV = zeros(numNonZeroBig,1);
numNonZeroCurr = 0;
while true
    ICOL = double(string(MatrixText(POS+[1:8])));
    rowBen = double(string(MatrixText(POS+[9:16])));
    rowEnd = double(string(MatrixText(POS+[17:24])));
    rowRange = rowBen:rowEnd;
    POS = POS + 24;
    NeedValueNum = length(rowRange);
    ValueText = MatrixText([1:NeedValueNum*16]+POS);
    Value = double(string(reshape(ValueText,16,[])'));

    if numNonZeroCurr+NeedValueNum>numNonZeroBig
        II_0 = II;
        JJ_0 = JJ;
        VV_0 = VV;
        N_II_0 = length(II_0);
        numNonZeroBig = numNonZeroBig*10;
        II = zeros(numNonZeroBig,1);
        JJ = zeros(numNonZeroBig,1);
        VV = zeros(numNonZeroBig,1);
        II(1:N_II_0) = II_0;
        JJ(1:N_II_0) = JJ_0;
        VV(1:N_II_0) = VV_0;
    end

    index = numNonZeroCurr+[1:NeedValueNum];
    VV(index) = Value;
    II(index) = rowRange';
    JJ(index) = repmat(ICOL,NeedValueNum,1);

    numNonZeroCurr = numNonZeroCurr + NeedValueNum;
    POS = POS+NeedValueNum*16;

    if (POS+24) == N_Text
        break
    end
end
index = II~=0;
K = sparse(II(index),JJ(index),VV(index),NROW,NCOL);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% K



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% M
if isempty(M_TEXT)
    M = [];
else

    MatrixText = M_TEXT;
    fprintf(string(datetime('now'))+":Read Mass ...\n")
    tmp = textscan(MatrixText(1,:),'%s%d%d%d%d%d%s');
    NCOL = tmp{5};
    NROW = tmp{6};
    N_Text = length(MatrixText);

    POS = 84;
    numNonZeroBig = 20;
    II = zeros(numNonZeroBig,1);
    JJ = zeros(numNonZeroBig,1);
    VV = zeros(numNonZeroBig,1);
    numNonZeroCurr = 0;
    while true
        ICOL = str2double(MatrixText(POS+[1:8]));
        rowBen = double(string(MatrixText(POS+[9:16])));
        rowEnd = double(string(MatrixText(POS+[17:24])));
        rowRange = rowBen:rowEnd;
        POS = POS + 24;
        NeedValueNum = length(rowRange);
        ValueText = MatrixText([1:NeedValueNum*16]+POS);
        Value = double(string(reshape(ValueText,16,[])'));

        if numNonZeroCurr+NeedValueNum>numNonZeroBig
        II_0 = II;
        JJ_0 = JJ;
        VV_0 = VV;
        N_II_0 = length(II_0);
        numNonZeroBig = numNonZeroBig*10;
        II = zeros(numNonZeroBig,1);
        JJ = zeros(numNonZeroBig,1);
        VV = zeros(numNonZeroBig,1);
        II(1:N_II_0) = II_0;
        JJ(1:N_II_0) = JJ_0;
        VV(1:N_II_0) = VV_0;
        end

        index = numNonZeroCurr+[1:NeedValueNum];
        VV(index) = Value;
        II(index) = rowRange';
        JJ(index) = repmat(ICOL,NeedValueNum,1);

        numNonZeroCurr = numNonZeroCurr + NeedValueNum;
        POS = POS+NeedValueNum*16;

        if (POS+24) == N_Text
            break
        end
    end
    index = II~=0;
    M = sparse(II(index),JJ(index),VV(index),NROW,NCOL);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% M



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DOF
fprintf(string(datetime('now'))+":Read DOFs ...\n")
MatrixText = DOF_TEXT;
tmp = textscan(MatrixText(1,:),'%s%d%d%d%d%d%s');
NCOL = tmp{5};
NROW = tmp{6};
N_Text = length(MatrixText);

POS = 84;
numNonZeroBig = 20;
II = zeros(numNonZeroBig,1);
JJ = zeros(numNonZeroBig,1);
VV = zeros(numNonZeroBig,1);
numNonZeroCurr = 0;
while true
    ICOL = str2double(MatrixText(POS+[1:8]));
    rowBen = double(string(MatrixText(POS+[9:16])));
    rowEnd = double(string(MatrixText(POS+[17:24])));
    rowRange = rowBen:rowEnd;
    POS = POS + 24;
    NeedValueNum = length(rowRange);
    ValueText = MatrixText([1:NeedValueNum*8]+POS);
    Value = double(string(reshape(ValueText,8,[])'));
    POS = POS+NeedValueNum*8;

    if numNonZeroCurr+NeedValueNum>numNonZeroBig
        II_0 = II;
        JJ_0 = JJ;
        VV_0 = VV;
        N_II_0 = length(II_0);
        numNonZeroBig = numNonZeroBig*10;
        II = zeros(numNonZeroBig,1);
        JJ = zeros(numNonZeroBig,1);
        VV = zeros(numNonZeroBig,1);
        II(1:N_II_0) = II_0;
        JJ(1:N_II_0) = JJ_0;
        VV(1:N_II_0) = VV_0;
    end

    index = numNonZeroCurr+[1:NeedValueNum];
    VV(index) = Value;
    II(index) = rowRange';
    JJ(index) = repmat(ICOL,NeedValueNum,1);

    numNonZeroCurr = numNonZeroCurr + NeedValueNum;
    
    if (POS+24) == N_Text
        break
    end
end
index = II~=0;
DOF = sparse(II(index),JJ(index),VV(index),NCOL);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DOF

fprintf(string(datetime('now'))+":Read Over\n")

Model.K = K;
Model.M = M;
Model.DOF = DOF;