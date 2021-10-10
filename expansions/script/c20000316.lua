--紧急模块嵌合
local m=20000316
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()~=tp
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(function(c)
			return c:IsSetCard(0xfd3)and c:IsPublic()and c:IsAbleToDeckAsCost()end,tp,LOCATION_HAND,0,1,nil)end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,function(c)
			return c:IsSetCard(0xfd3)and c:IsPublic()and c:IsAbleToDeckAsCost()end,tp,LOCATION_HAND,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.t1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ft)end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local b1=Duel.IsExistingMatchingCard(cm.t1,tp,LOCATION_DECK,0,1,nil,e,tp,ft)
		local b2=Duel.IsExistingMatchingCard(cm.t2,tp,LOCATION_GRAVE,0,1,nil)
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
		elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
		else return end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.t1,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.t2,tp,LOCATION_GRAVE,0,1,2,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
end
function cm.t1(c,e,tp,ft)
	return c:IsSetCard(0xfd3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0
end
function cm.t2(c,e,tp,ft)
	return c:IsSetCard(0xfd3)and c:IsAbleToHand()
end