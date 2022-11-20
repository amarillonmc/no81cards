--悠悠飘落
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174070)
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
	e1:SetValue(cm.val)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	for p=0,1 do
		Duel.SetLP(p,Duel.GetLP(p)*2)
		local e2=rsef.FC({c,p},EVENT_PHASE+PHASE_END,{m,0},1,nil,nil,rscon.turns,cm.lpop)
	end
end
function cm.val(e,re,val,r,rp,rc)
	return val*2
end
function cm.lpop(e,tp)
	Duel.SetLP(tp,math.max(0,Duel.GetLP(tp)-1000))
end
