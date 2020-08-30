--天知骑士王 格拉姆灵王
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65010565,"TianZhi")
function cm.initial_effect(c)
	c:EnableReviveLimit(c)
	aux.AddFusionProcCodeFun(c,65010558,cm.fusfilter,1,true,true)
	local e3=rsef.QO(c,nil,{m,0},{1,m},"dr","ptg",LOCATION_MZONE,cm.drcon,nil,rsop.target(1,"dr"),cm.drop)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(cm.creg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon1)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.discon2)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	e0:SetLabelObject(e2)
	if cm.switch then return end
	cm.switch = {[0]=0,[1]=0}
	local ge1=rsef.FC({c,0},EVENT_CHAINING)
	ge1:SetOperation(cm.regop)
	local ge2=rsef.FC({c,0},EVENT_CHAIN_NEGATED)
	ge2:SetOperation(cm.regop2)
	local ge3=rsef.FC({c,0},EVENT_PHASE_START+PHASE_DRAW)
	ge3:SetOperation(cm.regop3)
end
function cm.fusfilter(c,fc)
	return c:IsLevelAbove(5) and c:IsRace(RACE_WYRM)
end
function cm.creg(e,tp,eg,ep,ev,re,r,rp)
	aux.chainreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
	local res = false
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetCode()==EVENT_SUMMON_SUCCESS or te:GetCode()==EVENT_SPSUMMON_SUCCESS then res = true end
	end	
	if res then e:GetLabelObject():SetLabel(100) end
end
function cm.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		cm.switch[rp]=cm.switch[rp]+1
	end
end
function cm.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		cm.switch[rp]=cm.switch[rp]-1
	end
end
function cm.regop3(e,tp)
	cm.switch = {[0]=0,[1]=0}
end
function cm.drcon(e,tp)
	return rscon.phmp(e,tp) and cm.switch[1-tp]>0
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)<=0 then return false end
	local te,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
	return  te:GetHandler():GetLocation() ~= loc and Duel.IsChainDisablable(ev) and loc & LOCATION_ONFIELD ~=0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	rshint.Card(m)
	Duel.NegateEffect(ev)
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	return rp ~= tp and Duel.IsChainNegatable(ev) and e:GetLabel()==100
end