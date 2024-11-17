--人理之基 大卫
function c22021130.initial_effect(c)
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021130,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(3,22021130+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c22021130.drtg)
	e1:SetOperation(c22021130.drop)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021130,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c22021130.atkcon)
	e3:SetOperation(c22021130.atkop)
	c:RegisterEffect(e3)
end
function c22021130.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22021130.drop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	Duel.NegateAttack()
	Duel.SelectOption(tp,aux.Stringid(22021130,2))
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c22021130.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x107f)
end
function c22021130.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(5000)
		c:RegisterEffect(e1)
	end 
	Duel.SelectOption(tp,aux.Stringid(22021130,3))
end
