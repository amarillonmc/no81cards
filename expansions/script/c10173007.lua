--次元呼唤
function c10173007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c10173007.disop)
	c:RegisterEffect(e2)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10173007.descon)
	c:RegisterEffect(e4)
end
function c10173007.descon(e)
	return not Duel.IsExistingMatchingCard(c10173007.acfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c10173007.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(c10173007.acfilter,re:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and bit.band(rc:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and not g:IsContains(rc) then
	   Duel.Hint(HINT_CARD,0,10173007)
	   Duel.NegateEffect(ev)
	   if rc:IsRelateToEffect(re) then
		  Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	   end
	end
end
function c10173007.acfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end