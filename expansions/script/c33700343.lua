--阻抗之髓 ~流动~
function c33700343.initial_effect(c)
	c:SetUniqueOnField(1,1,33700343)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700343,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c33700343.descon)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c33700343.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700343,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c33700343.thcon)
	e3:SetTarget(c33700343.thtg)
	e3:SetOperation(c33700343.thop)
	c:RegisterEffect(e3)		
end
function c33700343.desop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local bt=Duel.GetAttackTarget()
	if not bt then return false end
	if bt:IsControler(tp) then at,bt=bt,at end
	if not bt:IsRelateToBattle() then return end
	Duel.Hint(HINT_CARD,0,33700343)
	if Duel.Destroy(bt,REASON_EFFECT)~=0 and Duel.GetTurnPlayer()==1-tp then
	   Duel.SendtoHand(at,nil,REASON_EFFECT)
	end
end
function c33700343.descon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local bt=Duel.GetAttackTarget()
	if not bt then return false end
	if bt:IsControler(tp) then at,bt=bt,at end
	return at:IsSetCard(0x5449)
end
function c33700343.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_SZONE)
end
function c33700343.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c33700343.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
end
