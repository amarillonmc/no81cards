--巡命的煌印
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.E(c)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.tg2)
	e2:SetValue(cm.val2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.con3)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e2
function cm.tgf2(c,tp)
	return c:IsFaceup() and c:IsCode(20000100) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
		and c:IsCanChangePosition() and c:IsPosition(POS_FACEUP_ATTACK) and c:GetFlagEffect(m)==0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(cm.tgf2,nil,tp)
	if chk==0 then return #g>0 end
	g:KeepAlive()
	e:SetLabelObject(g)
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.val2(e,c)
	return cm.tgf2(c,e:GetHandlerPlayer())
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	g:DeleteGroup()
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,20000100)
end
function cm.tgf3(c)
	return c:IsSetCard(0x3fd1) and c:GetType()==0x20002
end
function cm.tgf3_1(c,tp)
	return c:GetActivateEffect():IsActivatable(tp)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf3,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.GetMatchingGroup(cm.tgf3,tp,LOCATION_DECK,0,nil):FilterSelect(tp,cm.tgf3_1,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end