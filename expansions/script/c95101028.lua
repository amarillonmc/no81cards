--失落帝国
function c95101028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,95101028+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c95101028.activate)
	c:RegisterEffect(e1)
	--unique
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(95101028)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xbba))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xbba))
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c95101028.thfilter(c)
	return c:IsSetCard(0xbba) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95101028.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95101028.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95101028,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
