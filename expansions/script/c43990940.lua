--象征世界的你与我
function c43990940.initial_effect(c)
	--leavl field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCondition(c43990940.lfcon)
	e0:SetOperation(c43990940.lfop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990940+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c43990940.activate)
	c:RegisterEffect(e1)
end
function c43990940.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and (not c:IsOnField() or not c:IsRelateToEffect(re))-- and re:IsActivated()
end
function c43990940.spfilter(c,e,tp)
	return c:IsSetCard(0x3511) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and aux.NecroValleyFilter()(c) and c:IsType(TYPE_MONSTER)
end
function c43990940.lfop(e,tp,eg,ep,ev,re,r,rp)
	--if not Duel.SelectYesNo(tp,aux.Stringid(43990940,2)) then return end
	Duel.Hint(HINT_CARD,0,43990940)
	Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(rp,c43990940.spfilter,rp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,rp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c43990940.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnPlayer()==tp and 1 or 2
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetCondition(c43990940.regcon)
	e0:SetOperation(c43990940.regop)
	e0:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c43990940.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
	Duel.RegisterEffect(e1,tp)
end
function c43990940.cfilter(c)
	return c:IsPreviousSetCard(0x3511) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c43990940.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990940.cfilter,1,nil)
end
function c43990940.regop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(43990940,2)) then return end
	Duel.Hint(HINT_CARD,0,43990940)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0x30,0x30,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c43990940.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3511) and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
