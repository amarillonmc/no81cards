local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+500)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end
function s.spcostfilter(c,tp)
	return c:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	if chk==0 then return g:IsExists(s.spcostfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:FilterSelect(tp,s.spcostfilter,1,1,nil,tp)
	Duel.SendtoGrave(tg,REASON_COST)
end
function s.scfilter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsSetCard(0x30) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.scfilter2,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function s.scfilter2(c,mg)
	return c:IsSetCard(0x30) and c:IsSynchroSummonable(nil,mg)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.scfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.scfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if not tc or not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	tc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	if not c:IsRelateToEffect(e) then return end
	Duel.AdjustAll()
	local mg=Group.FromCards(c,tc)
	if mg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(s.scfilter2,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.filter(c)
	return c:IsSetCard(0x30) and c:IsFaceupEx() and c:IsAbleToDeckOrExtraAsCost()
end
function s.fselect(g,c)
	return g:IsContains(c)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local sct=5
	while sct<#g do
		if Duel.IsPlayerCanDraw(tp,sct/5) then sct=sct+5 else sct=sct-1 break end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,s.fselect,false,1,math.min(sct,#g),c)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*200)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,math.floor(ct/5))
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and d>=1000 then
		Duel.BreakEffect()
		Duel.Draw(p,math.floor(d/1000),REASON_EFFECT)
	end
end
