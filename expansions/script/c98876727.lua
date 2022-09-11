--寻芳精之出游
function c98876727.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,98876727)   
	e1:SetTarget(c98876727.target)
	e1:SetOperation(c98876727.activate)
	c:RegisterEffect(e1) 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,18876727)
	e2:SetTarget(c98876727.reptg)
	e2:SetValue(c98876727.repval)
	e2:SetOperation(c98876727.repop)
	c:RegisterEffect(e2)
end
function c98876727.filter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x988) and c:IsAbleToHand()
end
function c98876727.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98876727.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98876727.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98876727.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98876727.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x988) and c:GetReasonPlayer()==1-tp 
		and c:IsOnField() and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c98876727.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c98876727.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c98876727.repval(e,c)
	return c98876727.repfilter(c,e:GetHandlerPlayer())
end
function c98876727.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
