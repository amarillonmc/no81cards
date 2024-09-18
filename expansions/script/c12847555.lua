-- 古木寻斋
local m=12847555
local cm=_G["c"..m]
function cm.initial_effect(c)
	-- special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e0:SetCondition(cm.sprcon)
	e0:SetTarget(cm.sprtg)
	e0:SetOperation(cm.sprop)
	c:RegisterEffect(e0)
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0xff)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	-- act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	-- disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetTarget(cm.distarget)
	c:RegisterEffect(e3)
	-- disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.disoperation)
	c:RegisterEffect(e4)
end
function cm.sprfilter(c,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and c:IsCode(m+1) and c:IsReleasable(REASON_SPSUMMON)
end
function cm.fselect(g,tp,sc)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	return g:CheckSubGroup(cm.fselect,1,#g,tp,c)
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,cm.fselect,true,1,#g,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function cm.check(c)
	return not c:IsCode(m+1) and c:IsType(TYPE_MONSTER)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.check,tp,0,0xff,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(m+1)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		tc:RegisterEffect(e1)
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(m+1)
end
function cm.distarget(e,c)
	return c~=e:GetHandler() and c:IsCode(m+1)
end
function cm.disoperation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(m+1) and re:GetHandler():IsFaceup() then
		Duel.NegateEffect(ev)
	end
end