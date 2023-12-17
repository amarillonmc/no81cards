--Kamipro 罗慕路斯
function c50213160.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c50213160.xcheck,4,2,c50213160.ovfilter,aux.Stringid(50213160,0),2,c50213160.xyzop)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_ALL-ATTRIBUTE_DIVINE-ATTRIBUTE_FIRE)
	e1:SetCondition(c50213160.attcon)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c50213160.atklimit)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c50213160.desreptg)
	e3:SetValue(c50213160.desrepval)
	e3:SetOperation(c50213160.desrepop)
	c:RegisterEffect(e3)
end
function c50213160.xcheck(c)
	return c:IsSetCard(0xcbf)
end
function c50213160.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:GetCounter(0xcbf)>=5
end
function c50213160.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50213160)==0 end
	Duel.RegisterFlagEffect(tp,50213160,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c50213160.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c50213160.atklimit(e,c)
	return c~=e:GetHandler()
end
function c50213160.repfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c50213160.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c50213160.repfilter,1,nil,e,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c50213160.desrepval(e,c)
	return c50213160.repfilter(c,e,e:GetHandlerPlayer())
end
function c50213160.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,50213160)
end