--救祓少女超越灵魂
local m=60002101
local cm=_G["c"..m]
cm.name="救祓少女超越灵魂"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.rcon)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
	--Cannot Become Target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.immtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function cm.rfilter(c,oc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,oc,REASON_COST)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsActivated()
		and re:IsActiveType(TYPE_XYZ) and ep==e:GetOwnerPlayer() and rc:IsSetCard(0x172)
		and Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_MZONE,0,1,rc,ev,tp)
end



function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local rc=re:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_MZONE,0,1,1,rc,min,tp)
	return tg:GetFirst():RemoveOverlayCard(tp,min,max,REASON_EFFECT)
end
function cm.immtg(e,c)
	return c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end