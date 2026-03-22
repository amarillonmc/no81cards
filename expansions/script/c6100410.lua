--魅影魔女-柯露雪
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.seqfilter(c)
	return c:GetSequence()<5
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local mz = Duel.GetMatchingGroupCount(s.seqfilter, tp, LOCATION_MZONE, 0, nil)
	local sz = Duel.GetMatchingGroupCount(s.seqfilter, tp, LOCATION_SZONE, 0, nil)
	return mz==0 or sz==0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return e:GetHandler():IsAbleToHand(1-tp)
		and Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	
	if Duel.SendtoHand(c, 1-tp, REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		Duel.ShuffleHand(tp)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetLabelObject(tc) 
			e1:SetOperation(s.bounceop)
			Duel.RegisterEffect(e1, tp)
			
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e2:SetTarget(s.redirect_tg)
			e2:SetValue(LOCATION_DECKBOT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2, true)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		end
	end
end

function s.bounceop(e,tp,eg,ep,ev,re,r,rp)
	local tc = e:GetLabelObject()
	local bounced = false
	
	for rc in aux.Next(eg) do
		if rc:IsSummonType(SUMMON_TYPE_FUSION) or rc:IsSummonType(SUMMON_TYPE_SYNCHRO) 
			or rc:IsSummonType(SUMMON_TYPE_XYZ) or rc:IsSummonType(SUMMON_TYPE_LINK) then
			local mats = rc:GetMaterial()
			if mats and mats:IsContains(tc) then
				Duel.SendtoDeck(rc, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
				bounced = true
			end
		end
	end
	
	if bounced then
		e:Reset()
	elseif not (tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup()) then
		e:Reset()
	end
end

function s.redirect_tg(e,c)
	local attr = e:GetHandler():GetAttribute()
	return attr ~= 0 and c:IsAttribute(attr)
end