--术结天缘神 菲娅
function c67200429.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c67200429.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67200429)
	e1:SetTarget(c67200429.thtg)
	e1:SetOperation(c67200429.thop)
	c:RegisterEffect(e1)	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c67200429.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
end
function c67200429.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x5671)
end
--
function c67200429.filter(c)
	return c:IsSetCard(0x3671) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200429.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200429.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200429.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200429.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200429.indtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
