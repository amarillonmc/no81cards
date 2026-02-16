--雪域生灵 猫崽
--Snowland Creature
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5226) and c:IsType(TYPE_LINK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.thfilter(c)
	return c:IsSetCard(0x5226) and c:IsAbleToHand()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local turn_tp=Duel.GetTurnPlayer()==tp
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
			or not e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		if turn_tp then
			return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if turn_tp then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if Duel.GetTurnPlayer()==tp then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.LinkSummon(tp,tc,nil)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_BEAST+RACE_WINDBEAST)
end
function s.cfilter(c)
	return c:GetFlagEffect(id)>0 and c:IsFaceup()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then return false end
	if not (re:GetHandler():IsSetCard(0x5226) and re:IsActiveType(TYPE_MONSTER) and rp==tp) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsControler,nil,1-tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		local tc=g:GetFirst()
		if g:GetCount()>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetCondition(s.econ)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		tc:RegisterFlagEffect(11614056,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.efilter(e,te)
	return te:GetHandler():GetControler()==e:GetHandler():GetControler()
end
function s.econ(e)
	local c=e:GetOwner()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end