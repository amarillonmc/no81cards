--虚毒概念 辩证法
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700711
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.FusionMaterialFunction(c,4)
	rsve.ToGraveFunction(c,2)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.ctcon2)
	e3:SetOperation(cm.ctop2)
	c:RegisterEffect(e3)
end
function cm.ctcon(e)
	return e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function cm.ctop(e)
	e:GetHandler():AddCounter(COUNTER_NEED_ENABLE+0x144b,1)
end
function cm.ctcon2(e)
	local bc=e:GetHandler():GetEquipTarget()
	return bc and bc:IsSetCard(0x144b) and Duel.GetAttacker()==bc
end
function cm.ctop2(e)
	local bc=e:GetHandler():GetEquipTarget()
	if not e:GetHandler():IsRelateToEffect(e) or not bc:IsRelateToBattle() then return end
	bc:AddCounter(0x144b,1)
	--Duel.RaiseEvent(bc,EVENT_CUSTOM+33700711,e,REASON_EFFECT,tp,tp,1)
end
