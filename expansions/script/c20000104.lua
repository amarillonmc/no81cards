--巡命的裁决
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.E(c)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.conf2(c,tp)
	if not (c:IsSetCard(0x3fd1) and (c:GetType()==0x20002 or c:IsType(TYPE_FIELD))) then return end
	return tp and c:GetActivateEffect():IsActivatable(tp) or c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conf2,tp,LOCATION_SZONE,0,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.conf2,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cm.conf2,tp,LOCATION_REMOVED,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		tc=Duel.SelectMatchingCard(tp,cm.conf2,tp,LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
		Duel.MoveToField(tc,tp,tp,tc:IsType(TYPE_FIELD) and LOCATION_FZONE or LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local cost=te:GetCost()
		if cost then cost(te,tc:GetControler(),eg,ep,ev,re,r,rp,1) end
	end
end