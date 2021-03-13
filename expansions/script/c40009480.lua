--龙血师团-†真红冲击†-
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009480)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c)
	local e3 = rsef.FTO(c,EVENT_BATTLE_START,"atk",1,"atk",nil,LOCATION_FZONE,cm.acon,rscost.lpcost(1000),nil,cm.aop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3f1b))
	e2:SetValue(0x20002)
	c:RegisterEffect(e2)
end
function cm.acon(e,tp)
	local tc = Duel.GetBattleMonster(tp)
	return tc and tc:IsSetCard(0x3f1b)
end
function cm.aop(e,tp)
	local g = Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1 = rscf.QuickBuff({e:GetHandler(),tc},"atk+",1000)
	end
end