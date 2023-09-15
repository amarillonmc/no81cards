local m=15000189
local cm=_G["c"..m]
cm.name="做了场奇怪的梦"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Dream
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(15000189)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	if not cm.DreamCheck then
		cm.DreamCheck=true
		_DreamIsRelateToEffect=Card.IsRelateToEffect
		function Card.IsRelateToEffect(c,e)
			local b1=Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_SZONE,LOCATION_SZONE,1,nil,e)
			local b2=(e:GetHandler()==c and e:IsActivated())
			if b1 and b2 then return false end
			return _DreamIsRelateToEffect(c,e)
		end
	end
end
function cm.cfilter(c,se)
	local ce=nil
	if c:GetEffectCount(15000189)~=0 then
		ce=c:IsHasEffect(15000189)
	end
	return c:GetEffectCount(15000189)~=0 and c:IsFaceup() and c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsDisabled() and not se:GetHandler():IsImmuneToEffect(ce)
end