--虚空魔术师之杖
function c85551815.initial_effect(c)
	aux.AddCodeList(c,46986414)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),3,2,c85551815.ovfilter,aux.Stringid(85551815,1))
	c:EnableReviveLimit()
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45702014,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,85551815)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c85551815.xyztg)
	e2:SetOperation(c85551815.xyzop)
	c:RegisterEffect(e2)
	--act qp/trap in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(c85551815.target)
	e1:SetCondition(c85551815.handcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(85551815)
	c:RegisterEffect(e3)
	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCost(c85551815.costchk)
	e4:SetTarget(c85551815.costtg)
	e4:SetOperation(c85551815.costop)
	c:RegisterEffect(e4)
end
function c85551815.ovfilter(c)
	return c:IsLevelBelow(3) and aux.IsCodeListed(c,46986414) and c:IsFaceup()
end
function c85551815.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,85551815)==0 end
	Duel.RegisterFlagEffect(tp,85551815,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c85551815.xyzfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsXyzSummonable(nil)
end
function c85551815.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85551815.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c85551815.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c85551815.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(c85551815.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
function c85551815.handcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c85551815.target(e,c)
	return aux.IsCodeListed(c,46986414)
end
function c85551815.costtg(e,te,tp)
	local tc=te:GetHandler()
	return tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(85551815)>0
		and ((tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(85551815) and tc:IsType(TYPE_QUICKPLAY) and Duel.GetTurnPlayer()~=e:GetHandlerPlayer())
			or (tc:GetEffectCount(EFFECT_TRAP_ACT_IN_HAND)<=tc:GetEffectCount(85551815) and tc:IsType(TYPE_TRAP)))
end
function c85551815.costchk(e,te_or_c,tp)
	return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c85551815.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,85551815)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
