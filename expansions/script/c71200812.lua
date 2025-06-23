--深渊的呼唤VIII 再生研习
local cm, m = GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71200800)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.e1f1(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsSetCard(0x899)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e1f1,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetTargetCard(g:Select(tp,1,1,nil))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.e1f2(c)
	return c:IsFaceup() and c:IsCode(71200800)
end
function cm.e1f3(c)
	return c:IsSetCard(0x899) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g = Duel.GetMatchingGroup(cm.e1f3,tp,LOCATION_DECK,0,nil)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 
		and Duel.IsExistingMatchingCard(cm.e1f2,tp,LOCATION_MZONE,0,1,nil)
		and #g > 0 and Duel.SelectYesNo(tp,1190) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g = g:Select(tp,1,1,nil)
		if #g==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
