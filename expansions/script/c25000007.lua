--根源破灭魔人 基布普
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000007)
function cm.initial_effect(c)
	local e1=rszg.XyzSumFun(c,m,6,25000009)
	local e2=rsef.SV_INDESTRUCTABLE(c,"effect",aux.indoval)
	local e3=rsef.QO(c,nil,{m,0},{1,m+600},"atk,def,dis",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target(cm.disfilter,"dis",0,LOCATION_MZONE),cm.disop)
end
function cm.disfilter(c,e,tp)
	return c:IsFaceup() and (c:IsAttackAbove(1) or c:IsDefenseAbove(1) or aux.disfilter1(c))
end
function cm.disop(e,tp)
	rsop.SelectSolve(HINTMSG_FACEUP,tp,cm.disfilter,tp,0,LOCATION_MZONE,1,1,nil,{cm.disfun,e:GetHandler()})
end
function cm.disfun(g,c)
	local e1,e2,e3,e4=rscf.QuickBuff({c,g:GetFirst()},"dis,dise",true,"atk,def",0)
end