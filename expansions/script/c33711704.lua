--激叫早
local m=33711704
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil)and Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,0,0)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,true,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if num<ft then ft = num end 
	if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft=1 end
	if num==0 then return end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		local a=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,1-tp,LOCATION_HAND,0,1,nil,e,tp)
		local op=1
		if a then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
		end
		local sg=g:Filter(cm.spfilter,nil,e,tp)
		local tdg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg1=sg:Select(1-tp,ft,ft,nil)
			if Duel.SpecialSummon(sg1,0,1-tp,1-tp,true,false,POS_FACEUP)~=0 then
				local lv=sg1:GetSum(Card.GetLevel)
				Duel.Damage(1-tp,lv*500,REASON_EFFECT)
			else
				Duel.Damage(1-tp,3000,REASON_EFFECT)
			end
		else
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local sg1=sg:Select(1-tp,ft,ft,nil)
			if Duel.SendtoDeck(sg1,nil,2,REASON_RULE)~=0 then
				local og=Duel.GetOperatedGroup()
				local lv=sg1:GetSum(Card.GetLevel)
				Duel.Damage(tp,lv*500,REASON_EFFECT)
			else
				Duel.Damage(1-tp,3000,REASON_EFFECT)
			end
		end
	end
		
end
