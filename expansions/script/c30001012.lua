--对邪魂兵器 时空仲裁机关
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30001012)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	aux.AddLinkProcedure(c,nil,4,4)
	local e1=rsef.FV_IMMUNE_EFFECT(c,rsval.imoe,aux.TargetBoolFunction(Card.IsFaceup),{LOCATION_MZONE,0},cm.imcon)
	local e2=rsef.SV_IMMUNE_EFFECT(c,rsval.imng1)
	local e3=rsef.FV_LIMIT_PLAYER(c,"act",cm.actval,nil,{0,1})
	local e4=rsef.FC(c,EVENT_CHAIN_SOLVING)
	rsef.RegisterSolve(e4,cm.discon,nil,nil,cm.disop)
	local e5=rsef.QO(c,EVENT_CHAINING,{m,0},nil,"rm",nil,LOCATION_MZONE,cm.rmcon,rscost.reglabel(100),cm.rmtg,cm.rmop)
	local e6=rsef.QO(c,nil,{m,1},1,"sp",nil,LOCATION_REMOVED,nil,cm.spcost,rsop.target(rscf.spfilter2(),"sp"),cm.spop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x920)
end
function cm.imcon(e)
	local g=Duel.GetMatchingGroup(cm.cfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return g:GetClassCount(Card.GetCode)>=5
end
function cm.actval(e,re)
	return re:GetHandler():IsLocation(LOCATION_REMOVED)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp~=tp and loc & LOCATION_REMOVED ~=0 and Duel.IsChainDisablable(ev)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	rshint.Card(m)
	Duel.NegateEffect(ev)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.rmfilter(c,tp)
	if not c:IsAbleToRemove() then return false end
	local g=Duel.GetMatchingGroup(cm.cfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return g:GetClassCount(Card.GetCode)>=3 or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x920))
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then 
		if e:GetLabel()==100 then return
			g1:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3 and g2:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3 and Duel.IsExistingMatchingCard(cm.rmfilter,tp,rsloc.de,0,1,g1,tp)
		else
			return Duel.IsExistingMatchingCard(cm.rmfilter,tp,rsloc.de,0,1,nil,tp)
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		Duel.Remove((g1+g2),POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,rsloc.de)
end
function cm.rmop(e,tp)
	rsop.SelectRemove(tp,cm.rmfilter,tp,rsloc.de,0,1,1,nil,{},tp)
end
function cm.tdfilter(c)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x920))
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,c)
	if chk==0 then return #g>0 and g:FilterCount(Card.IsAbleToDeckOrExtraAsCost,nil)==#g end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end