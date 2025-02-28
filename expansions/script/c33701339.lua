--破·坏·拳
local m=33701339
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=1-Duel.RockPaperScissors(false)
	Duel.Damage(res,1000,REASON_EFFECT)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(res,m)==0 then 
		Duel.RegisterFlagEffect(res,m,RESET_PHASE+PHASE_END,0,1,ev)
	else
		local label=Duel.GetFlagEffectLabel(res,m)
		Duel.SetFlagEffectLabel(res,m,label+ev)
	end
	if Duel.GetFlagEffect(res,m)>=3000 then
		Duel.Damage(res,4999,REASON_EFFECT)
	end
end
