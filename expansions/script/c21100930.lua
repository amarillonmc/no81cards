--环球旅行的开端
local m=21100930
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.q(c,e,tp)
	return c:IsCode(21185682,21185730,21185756,21185759,21185762) and Duel.GetLocationCount(1-tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.q,tp,0x11,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0x11)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return not (e:GetHandler():IsType(TYPE_MONSTER) and e:GetHandler():IsOnField())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetLocationCount(1-tp,4)
	if x<=0 then return end
	if x>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then x=1 end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.q,tp,0x11,0,1,x,nil,e,tp)
	if #g>0 then
	Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
	end
end