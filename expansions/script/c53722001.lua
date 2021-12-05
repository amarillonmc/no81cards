local m=53722001
local cm=_G["c"..m]
cm.name="大祭环 天狗"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.GreatCircle(c)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(cm.repval)
	e5:SetOperation(cm.repop)
	c:RegisterEffect(e5)
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3531) and c:IsType(TYPE_MONSTER) and c:IsOnField() and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
		and ((c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))
		or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsPlayerCanDiscardDeck(tp,2) end
	return true
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.DiscardDeck(tp,2,REASON_EFFECT+REASON_REPLACE)
end
