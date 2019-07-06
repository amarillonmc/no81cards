--虚毒IDOL
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700705
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.NormalSummonFunction(c,2)   
	rsve.BattleFunction(c,2200) 
	rsve.DirectAttackFunction(c,5)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)  
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	rsve.addcounter(tp,5)
end