--怪兽机械 撒旦拉布摩斯
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001014)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,3,true)
	local e1=rscf.SetSummonCondition(c,false)
	local e2=aux.AddContactFusionProcedure(c,cm.cfilter,rsloc.hd+LOCATION_MZONE,0,cm.solvefun,c)
	local e3,e4=rsef.FV_CANNOT_DISABLE(c,"dise,act",nil,aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE),{LOCATION_MZONE,0})
	local e5=rsef.I(c,{m,0},1,"th,dis",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.thfilter,"th",rsloc.gr),cm.thop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and c:IsFaceup()
end
function cm.thop(e,tp)
	local ct,og,tc=rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.gr,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_HAND) then
		rsop.SelectOC({m,1},true)
		rsop.SelectSolve(HINTMSG_DISABLE,tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil,cm.disfun,e:GetHandler())
	end
end
function cm.disfun(g,c)
	local tc=g:GetFirst()   
	local e1,e2=rscf.QuickBuff({c,tc},"dis,dise")
	return true
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_MACHINE) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function cm.cfilter(c)
	local tp=c:GetControler()
	if not c:IsAbleToGraveAsCost() then return false end
	return not c:IsLocation(LOCATION_DECK) or (Duel.GetFlagEffect(tp,m)==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0)
end
function cm.solvefun(g,c)
	local tp=c:GetControler()
	local atk=g:GetSum(Card.GetTextAttack)
	local def=g:GetSum(Card.GetTextDefense)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
	end
	Duel.SendtoGrave(g,REASON_COST)
	local e1,e2=rsef.SV_SET(c,"batk,bdef",{atk,def},nil,rsreset.est_d-RESET_TOFIELD)
end 