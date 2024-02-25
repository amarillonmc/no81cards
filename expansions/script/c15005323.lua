local m=15005323
local cm=_G["c"..m]
cm.name="空无矩尺·拉尼亚凯亚"
function cm.initial_effect(c)
	--Xyz Summon
	aux.AddXyzProcedure(c,nil,13,3)
	c:EnableReviveLimit()
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(0xff)
	e1:SetCondition(cm.wincon)
	e1:SetOperation(cm.winop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_LANIAKEA=0xf4
	local p=rp
	Duel.Win(p,WIN_REASON_LANIAKEA)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end