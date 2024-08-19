--奥法集装士『归根何处』
function c60010097.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60010097,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c60010097.spcon)
	e1:SetTarget(c60010097.sptg)
	e1:SetOperation(c60010097.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60010097,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c60010097.cfmcon)
	e2:SetTarget(c60010097.cfmtg)
	e2:SetOperation(c60010097.cfmop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60010097,5))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,60010097)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c60010097.tg)
	e3:SetOperation(c60010097.op)
	c:RegisterEffect(e3)
end
function c60010097.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c60010097.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function c60010097.gcheck(sg)
	return sg:GetSum(Card.GetLevel)<=5
end
function c60010097.fselect(g,tp,c)
	return g:CheckWithSumEqual(Card.GetLevel,5,g:GetCount(),g:GetCount()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>g:GetCount() 
end
function c60010097.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60010097.spfilter,tp,LOCATION_HAND,0,c,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE))+1,g:GetCount())
	if chk==0 then
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		aux.GCheckAdditional=c60010097.gcheck
		local res=g:CheckSubGroup(c60010097.fselect,1,ft,tp,e:GetHandler())
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c60010097.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.SpecialSummonStep(c,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(c60010097.spfilter,tp,LOCATION_HAND,0,c,e,tp)
		local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),g:GetCount())
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		aux.GCheckAdditional=c60010097.gcheck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c60010097.fselect,false,1,ft,tp,nil)
		aux.GCheckAdditional=nil
		if sg then
			local tc=sg:GetFirst()
			while tc do
				if tc:IsSetCard(0x634) and tc:IsType(TYPE_RITUAL+TYPE_MONSTER) then
					Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
				else
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				end
				tc=sg:GetNext()
			end
		end
		Duel.SpecialSummonComplete()
	end
end
--
function c60010097.cfmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c60010097.cfmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c60010097.cfmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=3 then return end
	if Duel.ConfirmDecktop(tp,3)~=0 then
		local g=Duel.GetDecktopGroup(tp,3)
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
			e:GetHandler():RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2))
		end
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
			e:GetHandler():RegisterFlagEffect(60010096,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,3))
		end
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
			e:GetHandler():RegisterFlagEffect(60010097,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,4))
		end
		if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,c,0x634) then
			local gg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,1,c,0x634):GetFirst()
			if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
				gg:RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2))
			end
			if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
				gg:RegisterFlagEffect(60010096,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,3))
			end
			if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
				gg:RegisterFlagEffect(60010097,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,4))
			end  
		end
	end
	Duel.ShuffleDeck(tp)
end
function c60010097.thfilter(c)
	return c:IsSetCard(0x634) and c:IsAbleToHand() and bit.band(c:GetType(),TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER and not c:IsCode(60010097)
end
function c60010097.setfilter(c)
	return c:IsSetCard(0x634) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60010097.thfilter1(c)
	return c:IsAbleToHand() and c:IsFaceup()
end
function c60010097.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Card.GetFlagEffect(c,60010095)~=0) or (Card.GetFlagEffect(c,60010096)~=0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)) or (Card.GetFlagEffect(c,60010097)~=0 and Duel.IsExistingMatchingCard(c60010097.thfilter,tp,LOCATION_DECK,0,1,nil)) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c60010097.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Card.GetFlagEffect(c,60010095)~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end 
	if Card.GetFlagEffect(c,60010096)~=0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local gq=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #gq>0 then
			Duel.HintSelection(gq)
			Duel.Destroy(gq,REASON_EFFECT)
		end
	end
	if Card.GetFlagEffect(c,60010097)~=0 and Duel.IsExistingMatchingCard(c60010097.thfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60010097.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

