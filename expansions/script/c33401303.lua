--D.A.L Ratatoskr 战斗形态
function c33401303.initial_effect(c)
   --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33401303,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,33401303)
	e1:SetCondition(c33401303.condition)
	e1:SetTarget(c33401303.destg)
	e1:SetOperation(c33401303.desop)
	c:RegisterEffect(e1)
   --boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c33401303.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,33401303+10000)
	e4:SetCondition(c33401303.thcon)
	e4:SetTarget(c33401303.thtg)
	e4:SetOperation(c33401303.thop)
	c:RegisterEffect(e4)
end
function c33401303.cfilter(c,tp)
	return c:IsFaceup()  and c:IsSetCard(0x341)
end
function c33401303.condition(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.IsExistingMatchingCard(c33401303.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33401303.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return  Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33401303.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end		 
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end   
	if e:GetHandler():GetFlagEffect(33401303)==1 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else 
		e:GetHandler():RegisterFlagEffect(33401303,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function c33401303.pd(c)
	return c:IsSetCard(0x341) 
end
function c33401303.atkval(e,c)
	return Duel.GetMatchingGroupCount(c33401303.pd,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*100
end

function c33401303.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c33401303.thfilter(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(33401303)
end
function c33401303.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33401303.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33401303.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33401303.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end