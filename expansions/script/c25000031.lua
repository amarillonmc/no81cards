--超古代眷族 佐伽
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000031)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=rscf.SetSummonCondition(c,false,aux.ritlimit)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,0x1},"tg","tg,de,dsp",rscon.sumtype("rit"),nil,rstg.target(Card.IsAbleToGrave,"tg",0,LOCATION_ONFIELD),cm.tgop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,0x1},"dish","ptg,de,dsp",rscon.sumtype("rit"),nil,rsop.target(nil,"dish",0,1),cm.dishop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.reptg)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
	local e4=rsef.QO(c,nil,{m,2},{1,m+100},"se,th,dish",nil,LOCATION_HAND,nil,cm.thcost,rsop.target2(cm.fun,cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.mat_filter(c)
	return not c:IsLevel(6)
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function cm.dishop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if #g>0 then
		local sg=g:RandomSelect(p,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
function cm.repfilter(c)
	return rsoc.IsSet(c) and c:IsAbleToGrave()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsPlayerCanDiscardDeck(tp,3) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(25000025)
end
function cm.thop(e,tp)
	if rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})>0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end
