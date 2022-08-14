local m=25000093
local cm=_G["c"..m]
cm.name="月之茧"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.draw)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetRange(0xff)
	e2:SetTargetRange(0xff,0xff)
	e2:SetCost(cm.costchk)
	e2:SetOperation(cm.count2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_MSET_COST)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TO_GRAVE)
		ge3:SetCondition(cm.regcon)
		ge3:SetOperation(cm.regop)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	cm.chaining=true
end
function cm.costchk(e,te_or_c,tp)
	e:SetLabelObject(te_or_c)
	return true
end
function cm.count2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=0 then return end
	Duel.RegisterFlagEffect(0,m,0,0,1)
	local c=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetOperation(cm.reset2)
	c:RegisterEffect(e1)
end
function cm.reset2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,m)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.chaining=false
end
function cm.cfilter(c,tp)
	return not c:IsReason(REASON_BATTLE+REASON_EFFECT+REASON_MATERIAL) and not (c:IsReason(REASON_COST) and (cm.chaining or Duel.GetFlagEffect(0,m)==0)) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(function(c)return c:GetOriginalCode()==m end,1,nil) then return false end
	local v=0
	if eg:IsExists(cm.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c)return c:GetOriginalCode()==m end,nil)
	Duel.RaiseEvent(g,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ev==PLAYER_ALL
end
function cm.draw(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(PLAYER_NONE,0x16)
end
