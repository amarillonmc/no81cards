--Hololive虚拟主播 戌神沁音
function c33701320.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c33701320.val)
	c:RegisterEffect(e2)	
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c33701320.atkval)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c33701320.distg)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33701320.distg)
	c:RegisterEffect(e1)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c33701320.iop2)
	c:RegisterEffect(e6)
end
function c33701320.val(e,c)
	return c:GetMaterial():GetCount()*1300
end
function c33701320.xfil(c)
	return (c:IsSetCard(0x344c) or c:IsSetCard(0x445))
end
function c33701320.atkval(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c33701320.xfil,tp,LOCATION_MZONE,0,nil,1-tp)*500
end
function c33701320.distg(e,c)
	return not (c:IsSetCard(0x344c) or c:IsSetCard(0x445))
end
function c33701320.iop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	if x==0 then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.Hint(HINT_CARD,0,33701320)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,x,nil)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
	end
	end
end





