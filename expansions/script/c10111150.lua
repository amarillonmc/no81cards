function c10111150.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c10111150.ovfilter,aux.Stringid(10111150,0),3,c10111150.xyzop)
	c:EnableReviveLimit()
	--cannot change position
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111150,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10111150.cost)
	e2:SetTarget(c10111150.tg)
	e2:SetOperation(c10111150.op)
	c:RegisterEffect(e2)
    	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111150,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c10111150.rmcon)
	e3:SetTarget(c10111150.rmtg)
	e3:SetOperation(c10111150.desop)
	c:RegisterEffect(e3)
end    
function c10111150.ovfilter(c)
	return c:IsFaceup() and c:IsCode(66506689)
end
function c10111150.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10111150)==0 end
	Duel.RegisterFlagEffect(tp,10111150,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c10111150.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10111150.filter(c)
	return c:IsCanChangePosition()
end
function c10111150.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c10111150.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111150.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c10111150.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c10111150.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
	end
end
function c10111150.cfilter(c,tp)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return c:IsType(TYPE_MONSTER) and ((pp==0x1 and np==0x4) or (pp==0x4 and np==0x1))
end
function c10111150.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10111150.cfilter,1,nil,tp)
end
function c10111150.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10111150.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   if Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(10111150,3)) then
		 e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		 Duel.Draw(tp,1,REASON_EFFECT)
	   end
	end
end