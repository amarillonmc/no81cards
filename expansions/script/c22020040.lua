--人理之基 阿尔托莉雅·Alter
function c22020040.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--summon success
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e100:SetCode(EVENT_SPSUMMON_SUCCESS)
	e100:SetOperation(c22020040.sumsuc)
	e100:SetCountLimit(1,22020040+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e100)
	--attack cost
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_SINGLE)
	e103:SetCode(EFFECT_ATTACK_COST)
	e103:SetOperation(c22020040.atop)
	c:RegisterEffect(e103)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(22020040,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c22020040.cost)
	e1:SetOperation(c22020040.operation)
	c:RegisterEffect(e1)
	--half damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c22020040.rdcon)
	e2:SetOperation(c22020040.rdop)
	c:RegisterEffect(e2)
end
function c22020040.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("击垮他们！")
	Duel.RegisterEffect(e1,tp)
end
function c22020040.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("卑王铁槌！")
	Duel.RegisterEffect(e1,tp)
end
function c22020040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Debug.Message("消失吧")
end
function c22020040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1800)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
function c22020040.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xff9)
end
function c22020040.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0)
end