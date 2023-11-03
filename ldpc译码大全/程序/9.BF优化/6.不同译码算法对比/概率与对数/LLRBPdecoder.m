function [de_code]=LLRBPdecoder(re_code,H,rate,EbNo)

%**************************   initialization   ****************************
iterNumMax=100;          %最大迭代次数
sigmapower=1/(2*rate*EbNo);
Qo=2*re_code/sigmapower; %计算LLR BP 译码的初始值
[HRow,HCol]=size(H);

lqOrigMes=zeros([HRow,HCol]);
LQ=zeros([HRow,HCol]);
QoCopy=zeros([HRow,HCol]);
[row,col]=find(H);

QoCopy=repmat(Qo,HRow,1);
lqOrigMes(logical(H))=QoCopy(logical(H));
LQ=lqOrigMes;
%initiate variable nodes passing to checking nodes message
operCount=0;
decodeFail=1;
chkNodeMes=zeros([HRow,HCol]);

%***************************  begin  decoding  ****************************  
while operCount<iterNumMax&decodeFail==1
    operCount=operCount+1;
    %operCount
    LQ=tanh(0.5*LQ);
    % variable node pass to checking node message
    for jChkNode=1:HRow
        linkNode=find(H(jChkNode,:));
        temp=[];
        for iVarNode=1:length(linkNode)
            temp=LQ(jChkNode,linkNode);
            temp(iVarNode)=[];
            computeTemp=prod(temp);% use prod function
            chkNodeMes(jChkNode,linkNode(iVarNode))=computeTemp;
        end
    end
    chkNodeMes=2*atanh(chkNodeMes);
    %compute the other checking nodes passing to variable node message
    computeTemp2=zeros(1,HCol);
    temp2=[];%????
    for iCol=1:HCol
        linkChkNode=find(H(:,iCol));
        temp2=chkNodeMes(linkChkNode,iCol);%qu chu yi lie
        for iTemp=1:length(linkChkNode)
            temp=[];
            temp=temp2;
            temp(iTemp)=[];
            %LQtemp(linkChkNode(iTemp),iCol)=sum(temp);
            LQ(linkChkNode(iTemp),iCol)=lqOrigMes(linkChkNode(iTemp),iCol)+sum(temp);
            %change iterative message
        end
        %compute judging soft message
        computeTemp2(iCol)=sum(temp2);
    end
    %compute hard judging message
    judgeMes=Qo+computeTemp2;
    %hard judge
    judgeCode=(1-sign(judgeMes))/2;
   
    %judge whether decoding done,or continue iterative decoding;
    decodeFail=~(sum(mod(H*judgeCode',2))==0);
end

de_code=judgeCode;

