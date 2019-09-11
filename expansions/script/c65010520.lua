--URBEX ACTION-摄影
function c65010520.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,65010520)
	e1:SetCondition(c65010520.con)
	e1:SetTarget(c65010520.tg)
	e1:SetOperation(c65010520.op)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65010520.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
c65010520.setname="URBEX"
function c65010520.target(e,c)
	return c.setname=="URBEX"
end
function c65010520.confil(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsControler(tp) and c.setname=="URBEX"
end
function c65010520.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65010520.confil,1,nil,tp)
end
function c65010520.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c65010520.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable() and tc.setname=="URBEX" and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(65010520,0)) then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end