local m=15004204
local cm=_G["c"..m]
cm.name="虚实写笔-狼"
function cm.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6f31),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,15004204)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6f31) and c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local x=0
		if e:GetLabel()==100 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
				x=1
			end
			e:SetLabel(10)
		end
		return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)) or x==1
	end
	local x=0
	if e:GetLabel()==100 or e:GetLabel()==10 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
			x=1
		end
	end
	if x==1 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_GRAVE
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if dv1&LOCATION_DECK~=0 then loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rp==1-tp and Duel.IsChainDisablable(ev) and c:GetFlagEffect(15004205)==0 and re:IsActiveType(TYPE_MONSTER)
		and ((not rc:IsFaceup()) or (not rc:IsOnField()))
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,15004205)
		Duel.NegateEffect(ev)
		c:RegisterFlagEffect(15004205,RESET_PHASE+PHASE_END,0,0)
	end
end