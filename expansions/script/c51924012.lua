--暗月马戏团开幕
function c51924012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,51924012)
	e1:SetTarget(c51924012.target)
	e1:SetOperation(c51924012.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51924012)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c51924012.reptg)
	e2:SetValue(c51924012.repval)
	e2:SetOperation(c51924012.repop)
	c:RegisterEffect(e2)
end
function c51924012.thfilter(c)
	return c:IsSetCard(0x3256) and not c:IsCode(51924012) and c:IsAbleToHand()
end
function c51924012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51924012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c51924012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c51924012.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c51924012.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3256) and c:IsOnField() and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c51924012.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c51924012.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c51924012.repval(e,c)
	return c51924012.repfilter(c,e:GetHandlerPlayer())
end
function c51924012.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,51924012)
end
