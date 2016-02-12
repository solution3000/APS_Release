function [ RP_pred ] = Overpressure(a,b,c,Pves_pred,Pop,Buoy,RP_pred,RP0,RPmax )
%% ------------------ Disclaimer  ------------------
% 
% BG Group plc or any of its respective subsidiaries, affiliates and 
% associated companies (or by any of their respective officers, employees 
% or agents) makes no representation or warranty, express or implied, in 
% respect to the quality, accuracy or usefulness of this repository. The code
% is this repository is supplied with the explicit understanding and 
% agreement of recipient that any action taken or expenditure made by 
% recipient based on its examination, evaluation, interpretation or use is 
% at its own risk and responsibility.
% 
% No representation or warranty, express or implied, is or will be made in 
% relation to the accuracy or completeness of the information in this 
% repository and no responsibility or liability is or will be accepted by 
% BG Group plc or any of its respective subsidiaries, affiliates and 
% associated companies (or by any of their respective officers, employees 
% or agents) in relation to it.
%% ------------------ License  ------------------ 
% GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
%% github
% https://github.com/AnalysePrestackSeismic/
%% ------------------ FUNCTION DEFINITION ---------------------------------
%OVERPRESSURE Summary of this function goes here
%   Detailed explanation goes here

RP_op_beta=(8/10000)*(1-exp(-a/Pves_pred));
RP_op_max=RP0+((RPmax-RP0)*exp(-b/Pves_pred));
RP_op_min=RPmax-((RPmax-RP0)*exp(-c*Pves_pred));

RP_op=RP_op_max-((RP_op_max-RP_op_min)*exp(-RP_op_beta*Pves_pred));
alpha=RP_pred-RP_op;
RP_pred_op=RP_op_max-((RP_op_max-RP_op_min)*exp(-RP_op_beta*(Pves_pred-Pop-Buoy)));
RP_pred=RP_pred_op+alpha;

end

