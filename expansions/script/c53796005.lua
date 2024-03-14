local m=53796005
local cm=_G["c"..m]
cm.name="狐假虎威·回天"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m)>0 then return end
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetCode()==1100 or re:GetCode()==1101 or re:GetCode()==1102
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(m)==0 end,0,0xff,0xff,nil)
	if #g==0 then return end
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		if te:GetType()&0x9==0x9 and (te:GetCode()==1100 or te:GetCode()==1101 or te:GetCode()==1102) then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
		Duel.CreateToken(tc:GetOwner(),tc:GetOriginalCode())
		local op={}
		for _,v in pairs(cp) do
			if not SNNM.IsInTable(v:GetOperation(),op) then
				v:SetCode(EVENT_LEAVE_FIELD)
				v:SetReset(RESET_PHASE+PHASE_END)
				f(tc,v,true)
				table.insert(op,v:GetOperation())
			end
		end
		cp={}
	end
	Card.RegisterEffect=f
end
