--翩翩行过
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174071)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:SetOperation(cm.act)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	Duel.RegisterEffect(e2,tp)
	for p=0,1 do
		Duel.SetLP(p,math.floor(Duel.GetLP(p)/2))
		local e3=rsef.FC({c,p},EVENT_PHASE+PHASE_END,{m,0},1,nil,nil,rscon.turns,cm.lpop)
	end
end
function cm.lpop(e,tp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
