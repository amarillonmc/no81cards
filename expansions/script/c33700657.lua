if not pcall(function() require("expansions/script/c33700650") end) then require("script/c33700650") end
--破天神狐 ～意外的报告，有趣的展开，和随便的觉悟之卷
local m=33700657
local cm=_G["c"..m]
cm.named_with_ptsh=true
function cm.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:GetSummonPlayer()==tp and tc:IsFaceup() and re:GetHandler()==tc
end
function cm.filter(c,code)
	return sr_ptsh.check_set_ptsh(c) and c:IsType(TYPE_MONSTER) and c:IsCode(code)
end
function cm.filter1(c)
	return sr_ptsh.check_set_ptsh(c) and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
		tc:RegisterEffect(e2)
		 --atk down
		local atk=tc:GetAttack()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
		e2:SetValue(-atk)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end