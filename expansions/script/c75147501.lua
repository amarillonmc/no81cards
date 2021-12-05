--闪刀姬-时雨
function c75147501.initial_effect(c)
	c:SetSPSummonOnce(75147501)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c75147501.matfilter,2,2)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75147501,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c75147501.rmtg)
	e2:SetOperation(c75147501.rmop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75147501,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c75147501.spcon)
	e3:SetTarget(c75147501.sptg)
	e3:SetOperation(c75147501.spop)
	c:RegisterEffect(e3)
end
function c75147501.matfilter(c)
	return c:IsLinkSetCard(0x1115) and not c:IsLinkAttribute(ATTRIBUTE_WATER)
end
function c75147501.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c75147501.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,1-tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local tc=g:Select(1-tp,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c75147501.retcon)
	e1:SetOperation(c75147501.retop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	tc:RegisterFlagEffect(75147501,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1,fid)
end
function c75147501.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75147501)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75147501.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function c75147501.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c75147501.spfilter(c,e,tp,ec)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c75147501.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75147501.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75147501.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75147501.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP,0x60)
		end
	end
end
