--裁决的圣堂 高洁城堡
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.F(c)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(cm.tg)
	e2:SetValue(cm.val)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.tgf(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.tgf2(c)
	return c:IsSetCard(0x3fd1) and (c:GetType()==0x20002 or c:IsType(TYPE_FIELD)) and c:IsAbleToGrave()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.tgf,1,nil,tp) and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_REMOVED,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.val(e,c)
	return cm.tgf(c,e:GetHandlerPlayer())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgf2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN+REASON_REPLACE)
	Duel.Hint(HINT_CARD,0,m)
end
