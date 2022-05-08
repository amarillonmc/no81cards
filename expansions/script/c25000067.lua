local m=25000067
local cm=_G["c"..m]
cm.name="迈向灭亡之种"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft1,sg1=Duel.GetLocationCount(tp,LOCATION_MZONE),Group.CreateGroup()
	if ft1>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
		local g1=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg1=g1:Select(tp,1,ft1,nil)
			for tc1 in aux.Next(sg1) do
				Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				tc1:SetUniqueOnField(1,1,tc1:GetOriginalCode())
				tc1:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,e:GetHandler():GetFieldID())
			end
		end
	end
	local ft2,sg2=Duel.GetLocationCount(1-tp,LOCATION_MZONE),Group.CreateGroup()
	if ft2>0 then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
		local g2=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND,0,nil,e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		if #g2>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			sg2=g2:Select(1-tp,ft2,ft2,nil)
			for tc2 in aux.Next(sg2) do
				Duel.SpecialSummonStep(tc2,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
				tc2:SetUniqueOnField(1,1,tc2:GetOriginalCode())
				tc2:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,e:GetHandler():GetFieldID())
			end
		end
	end
	Duel.SpecialSummonComplete()
	if #sg1>0 then Duel.ConfirmCards(1-tp,sg1) end
	if #sg2>0 then Duel.ConfirmCards(tp,sg2) end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local loc1,loc2=0,0
	if not Duel.IsExistingMatchingCard(function(c)return c:GetFlagEffect(m)>0 and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,nil) then loc1=LOCATION_MZONE end
	if not Duel.IsExistingMatchingCard(function(c)return c:GetFlagEffect(m)>0 and c:IsFaceup()end,tp,0,LOCATION_MZONE,1,nil) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,loc1,loc2,nil)
	if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end
