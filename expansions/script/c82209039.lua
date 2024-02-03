local m=82209039
local cm=_G["c"..m]
--幻奏的音姬 孤高之海顿
function cm.initial_effect(c)
	--fusion summon  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9b),3,true)  
	--cannot spsummon  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetRange(LOCATION_EXTRA)  
	e0:SetValue(cm.splimit)  
	c:RegisterEffect(e0)  
	--remove  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)  
	e1:SetCountLimit(1)
	e1:SetTarget(cm.rmtg)  
	e1:SetOperation(cm.rmop)  
	c:RegisterEffect(e1) 
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_BATTLE_DESTROYING)  
	e2:SetCondition(aux.bdocon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
	--spsummon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetCountLimit(1,m)  
	e3:SetCondition(cm.spcon2)
	e3:SetCost(cm.spcost2)
	e3:SetTarget(cm.sptg2)  
	e3:SetOperation(cm.spop2)  
	c:RegisterEffect(e3)  
end
function cm.splimit(e,se,sp,st)  
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION  
end  
function cm.rmfilter(c)
	return c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(cm.rmfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() and chkc~=c end 
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)  
end  
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	while tc do
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and not tc:IsReason(REASON_REDIRECT) then 
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_FIELD)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)  
			e1:SetTarget(cm.distg)  
			e1:SetLabelObject(tc)  
			e1:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e1,tp)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
			e2:SetCode(EVENT_CHAIN_SOLVING)  
			e2:SetCondition(cm.discon)  
			e2:SetOperation(cm.disop)  
			e2:SetLabelObject(tc)  
			e2:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e2,tp)  
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_FIELD)  
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
			e3:SetTarget(cm.distg)  
			e3:SetLabelObject(tc)  
			e3:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e3,tp)  
		end
		tc=g:GetNext()
	end  
end  
function cm.distg(e,c)  
	local tc=e:GetLabelObject()  
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateEffect(ev)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x9b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
function cm.costfilter(c)  
	return c:IsSetCard(0x9b) and c:IsAbleToRemoveAsCost()  
end  
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION) 
end  
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,c)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)  
end  
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then  
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_ATTACK_ALL)  
		e1:SetValue(cm.atkfilter)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)   
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_UPDATE_ATTACK)  
		e2:SetValue(-400)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)  
		c:RegisterEffect(e2) 
		Duel.SpecialSummonComplete()
	end  
end  
function cm.atkfilter(e,c)  
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)  
end  