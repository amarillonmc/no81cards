--契龙圣约 银河之圣守
local m=33201270
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201250") end,function() require("script/c33201250") end)
function cm.initial_effect(c)
	VHisc_Dragonk.eqa(c)
	--Def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+CATEGORY_TOHAND)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	VHisc_Dragonk.eqgef(c,e2)
end
cm.VHisc_DragonRelics=true

--e2
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	if Duel.NegateAttack() and ac:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.SendtoHand(ac,nil,REASON_EFFECT)
	end
end
