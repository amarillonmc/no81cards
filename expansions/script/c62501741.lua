--蚀痕无命 契誓神启
function c62501741.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xea4),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,1,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501741.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local se0=Effect.CreateEffect(c)
	se0:SetType(EFFECT_TYPE_FIELD)
	se0:SetCode(EFFECT_SPSUMMON_PROC)
	se0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se0:SetRange(LOCATION_EXTRA)
	--se0:SetValue(SUMMON_TYPE_FUSION)
	se0:SetCondition(c62501741.sprcon)
	se0:SetTarget(c62501741.sprtg)
	se0:SetOperation(c62501741.sprop)
	c:RegisterEffect(se0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e1:SetDescription(aux.Stringid(62501741,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,62501741)
	e1:SetCost(c62501741.thcost)
	e1:SetTarget(c62501741.thtg)
	e1:SetOperation(c62501741.thop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501741+1)
	e2:SetTarget(c62501741.rmtg)
	e2:SetOperation(c62501741.rmop)
	c:RegisterEffect(e2)
	c62501741.remove_event_effect=e2
end
function c62501741.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c62501741.matfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c62501741.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c62501741.matfilter,tp,LOCATION_REMOVED,0,nil)
	return #mg>=6 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501741.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c62501741.matfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,aux.TRUE,true,6,6,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c62501741.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
end
function c62501741.rmfilter(c)
	return c:IsSetCard(0xea4) and not c:IsCode(62501741) and c:IsAbleToRemoveAsCost(POS_FACEDOWN) and c:IsFaceupEx()
end
function c62501741.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 or Duel.IsExistingMatchingCard(c62501741.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c62501741.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if #g==3 then
		Duel.DisableShuffleCheck()
	end
	g:Merge(sg)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c62501741.thfilter(c)
	return c:IsSetCard(0xea4) and c:IsAbleToHand() and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED)) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c62501741.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501741.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c62501741.gcheck(sg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c62501741.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c62501741.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,c62501741.gcheck,false,1,3)
	--Duel.HintSelection(sg)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 or not Duel.SelectYesNo(tp,aux.Stringid(62501741,2)) then return end
	Duel.BreakEffect()
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
end
function c62501741.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==#g and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function c62501741.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(tp,3)
	local c=e:GetHandler()
	if not rg or #rg==0 or Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if not cg or #cg==0 then return end
	Duel.ConfirmCards(tp,cg)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_EXTRA,nil,tp,POS_FACEDOWN)
		g:Merge(Duel.GetDecktopGroup(1-tp,1))
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(1-tp,c62501741.gcheck,false,3,3)
		if sg and #sg>0 then
			Duel.BreakEffect()
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEDOWN,REASON_RULE,1-tp)
		end
	end
end
