--坎特伯雷森林旅馆
function c65110014.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65110014+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c65110014.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65110014.target)
	e2:SetValue(c65110014.indct)
	c:RegisterEffect(e2)
end
function c65110014.target(e,c)
	return c:IsSetCard(0x831)or c:IsSetCard(0x832)
end
function c65110014.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c65110014.filter(c)
	return c:IsCode(65110015) and c:IsAbleToHand()
end
function c65110014.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65110014.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		while not Duel.SelectYesNo(tp,aux.Stringid(65110014,0)) do
			
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end