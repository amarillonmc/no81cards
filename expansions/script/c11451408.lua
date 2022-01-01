--traveler saga kyoukaisen
--21.04.10
local m=11451408
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
cm.traveler_saga=true
function cm.filter(c,seq)
	return c:GetSequence()==seq
end
function cm.mfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,63060238) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummon(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_DECK,0,nil,rc)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local tg=g:GetMinGroup(Card.GetSequence)
	if not tg or #tg==0 then
		Duel.ConfirmDecktop(tp,#dg)
		Duel.ShuffleDeck(tp)
		return
	end
	local tc=tg:GetFirst()
	local seq=tc:GetSequence()
	for i=seq,0,-1 do
		local mg=dg:Filter(cm.filter,nil,i)
		Duel.MoveSequence(mg:GetFirst(),0)
	end
	Duel.ConfirmDecktop(tp,seq+1)
	if tc:IsType(TYPE_RITUAL) and (tc.mat_filter or tc.mat_group_check) then
		Duel.ShuffleDeck(tp)
		return
	end
	local mg=Duel.GetDecktopGroup(tp,seq):Filter(cm.mfilter,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and #mg>=tc:GetLevel() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=mg:Select(tp,tc:GetLevel(),tc:GetLevel(),nil)
		tc:SetMaterial(g1)
		Duel.SendtoGrave(g1,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_REVEAL)
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_RITUAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
	Duel.ShuffleDeck(tp)
end