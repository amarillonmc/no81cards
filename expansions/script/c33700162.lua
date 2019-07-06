--甜蜜的小阁楼 ～幸福的回复时间～
function c33700162.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   --battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c33700162.indtg)
	e2:SetCondition(c33700162.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(33700162,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,33700162)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c33700162.thcon)
	e3:SetTarget(c33700162.thtg)
	e3:SetOperation(c33700162.thop)
	c:RegisterEffect(e3)
end
function c33700162.indtg(e,c)
	return c:IsSetCard(0x445)
end
function c33700162.indcon(e)
	 local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c33700162.tgfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsControler(tp)
		and c:IsReason(REASON_DESTROY) and c:IsSetCard(0x445) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33700162.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c33700162.tgfilter,nil,e,tp)==1
   and  Duel.GetLP(tp)>100
end
function c33700162.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,c33700162.tgfilter,1,1,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33700162.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
