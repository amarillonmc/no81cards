--虚拟水神剑士
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020211,"VrAqua")
function cm.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetValue(1)
	c:RegisterEffect(e1)	
end
