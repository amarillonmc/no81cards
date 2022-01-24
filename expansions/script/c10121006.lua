--大魔神 毁灭之王巴尔
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121006
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,10,3,nil,nil,99)
	--rsdio.XyzEffect(c,4)(暂时无法正常使用)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(1)
	e1:SetCondition(cm.con)
	e1:SetCountLimit(1)
	e1:SetCost(rscost.rmxyz(1))
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	c:RegisterEffect(e2)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--togr
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(cm.rtg)
	e3:SetCondition(cm.con)
	e3:SetLabel(3)
	e3:SetValue(cm.rval)
	e3:SetOperation(cm.rop)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e4)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetLabel(10)
	e5:SetCondition(cm.con)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_XMATERIAL)
	c:RegisterEffect(e6)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
	--cannot to Grave as cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(0x47,0x47)
	e6:SetCondition(cm.con)
	e6:SetLabel(3)
	e6:SetTarget(cm.cgtg)
	e6:SetValue(1)
	local e7=e6:Clone()
	e7:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	c:RegisterEffect(e7)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
end
function cm.cgtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.dfilter(c,tp)
	return c:GetDestination()==LOCATION_GRAVE and c:GetOwner()~=tp and not c:IsLocation(LOCATION_OVERLAY) and not c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_TOKEN)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.dfilter,1,nil,tp) and e:GetHandler():IsType(TYPE_XYZ) end
	local g=eg:Filter(cm.dfilter,nil,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.Overlay(e:GetHandler(),g)
	g:Clear()
end
function cm.rval(e,c)
	return cm.dfilter(c,e:GetHandlerPlayer())
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end