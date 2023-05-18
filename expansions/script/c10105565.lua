function c10105565.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c10105565.ovfilter,aux.Stringid(10105565,0),2,c10105565.xyzop)
	c:EnableReviveLimit()
    --addown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105565,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c10105565.adcost)
	e1:SetTarget(c10105565.adtg)
	e1:SetOperation(c10105565.adop)
	c:RegisterEffect(e1)
    end
function c10105565.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7cdd) and not c:IsCode(10105565)
end
function c10105565.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10105565)==0 end
	Duel.RegisterFlagEffect(tp,10105565,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c10105565.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10105565.filter(c)
	return c:IsFaceup() and c:GetAttribute()~=ATTRIBUTE_DARK
end
function c10105565.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105565.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c10105565.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10105565.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-900)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end