--时崎狂三-暗影之主
function c33400009.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,c33400009.mfilter,2)
	c:EnableReviveLimit()
	 --activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(c33400009.afilter))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	--SPECIAL_SUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabel(2)
	e2:SetCost(c33400009.cost)
	e2:SetCountLimit(1,33400009)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33400009.spcon)
	e2:SetTarget(c33400009.sptg)
	e2:SetOperation(c33400009.spop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,33400009+10000)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetLabel(2)
	e3:SetCost(c33400009.cost)
	e3:SetTarget(c33400009.destg)
	e3:SetOperation(c33400009.desop)
	c:RegisterEffect(e3)
end
function c33400009.mfilter(c)
	return c:IsLinkSetCard(0x3341)
end
function c33400009.afilter(c)
	return c:IsSetCard(0x3340) and c:IsType(TYPE_QUICKPLAY)
end
function c33400009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400009.cfilter(c,lg)
	return  lg:IsContains(c)
end
function c33400009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c33400009.cfilter,1,nil,lg)
end
function c33400009.filter(c,e,tp)
	return c:IsSetCard(0x3341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33400009.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33400009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400009.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  e1:SetValue(0)
		  tc:RegisterEffect(e1)
		  local e2=Effect.CreateEffect(e:GetHandler())
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		  e2:SetValue(0)
		  tc:RegisterEffect(e2)  
		  local fid=e:GetHandler():GetFieldID()
		  tc:RegisterFlagEffect(33400009,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		  local e3=Effect.CreateEffect(e:GetHandler())
		  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e3:SetCode(EVENT_PHASE+PHASE_END)
		  e3:SetCountLimit(1)
		  e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e3:SetLabel(fid)
		  e3:SetLabelObject(tc)
		  e3:SetCondition(c33400009.tgcon)
		  e3:SetOperation(c33400009.tgop)
		  Duel.RegisterEffect(e3,tp)
	end
end
function c33400009.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(33400009)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c33400009.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function c33400009.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3341)
end
function c33400009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c33400009.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c33400009.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c33400009.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end