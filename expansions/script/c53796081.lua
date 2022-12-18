local m=53796081
local cm=_G["c"..m]
cm.name="美大球"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	e1:SetOperation(cm.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(cm.setcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(cm.winop)
	c:RegisterEffect(e4)
end
function cm.rlfilter(c,tp)
	local bool=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local re={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)}
	local flag=c:IsType(TYPE_TRAP+TYPE_SPELL)
	if bool then
		for k,v in table.ipairs(re) do
			if not c:IsLocation(LOCATION_ONFIELD) and val(v,c,tp,tp)==true then
				flag=false
			end
		end
	end
	return c:IsReleasable() or flag
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Group.__sub(Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0),c)
	return minc<=85 and #g>84 and g:FilterCount(cm.rlfilter,nil,tp)==#g and Duel.GetMZoneCount(tp,g)>0
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.__sub(Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0),c)
	c:SetMaterial(g)
	Duel.Release(g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_ONFIELD),REASON_SUMMON+REASON_MATERIAL)
	Duel.SendtoGrave(g:Filter(Card.IsLocation,nil,LOCATION_DECK),REASON_SUMMON+REASON_MATERIAL+REASON_RELEASE)
end
function cm.setcon(e,c,minc)
	if not c then return true end
	return false
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_CREATORGOD=0x13
	local p=e:GetHandler():GetSummonPlayer()
	Duel.Win(p,WIN_REASON_CREATORGOD)
end
