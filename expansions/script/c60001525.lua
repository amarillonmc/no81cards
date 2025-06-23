--遗产的炮击
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsCode(60001504) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.drfil(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW) and c:IsSetCard(0x5622) and c:IsType(TYPE_MONSTER)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.drfil,1,nil,tp)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then Duel.Destroy(g,REASON_EFFECT)
	else Duel.Damage(1-tp,400,REASON_EFFECT) end
end