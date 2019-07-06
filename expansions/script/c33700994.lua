--残星倩影 夙愿开辟
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700994
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.DirectAttackFun(c,cm.con)
	rsss.DamageFunction(c,cm.op)   
	if not cm.check then
		cm.check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT ~=0 then
		local lab=Duel.GetFlagEffectLabel(tp,m)
		if not lab then lab=0 end
		Duel.RegisterFlagEffect(ep,m,rsreset.pend,0,1,ev+lab)
	end
end
function cm.con(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0
end
function cm.op(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end