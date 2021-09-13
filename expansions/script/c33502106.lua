--自然色彩 云粉玫瑰
Duel.LoadScript("c33502100.lua")
local m=33502106
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e9=Suyuz.tograve(c,CATEGORY_DISABLE+CATEGORY_RELEASE,m,cm.op)
	--HZ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(Suyuz.gaincon(m))
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.hop)
	c:RegisterEffect(e3)
	if not BZo_p then
		BZo_p={}
		BZo_p["Effects"]={}
	end
	BZo_p["Effects"]["c33502106"]=cm.disop
end
--e1
function cm.op(e,tp)
	local c=e:GetHandler()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.disop)
	e1:SetLabel(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabel()
	if te==re or not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and Duel.GetFlagEffect(tp,m)==0) then return end
	local tep=re:GetHandlerPlayer()
	if not Duel.IsExistingMatchingCard(cm.splimit0,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)  then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.splimit0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		local tc=g:GetFirst()
		if Duel.Release(tc,REASON_EFFECT)~=0 then
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e6:SetCode(EVENT_CHAIN_SOLVING)
			e6:SetReset(RESET_CHAIN)
			e6:SetOperation(cm.dis)
			Duel.RegisterEffect(e6,tp)
			Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
		end
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function cm.splimit0(c)
	return c:IsRace(RACE_PLANT) and c:IsReleasable()
end
function cm.dis(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateEffect(ev)
end
--e3
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_RELEASE_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetOperation(cm.repop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e3)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
end
function cm.repfilter(c,tp,re)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsRace(RACE_PLANT) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp,re)
		and e:GetHandler():IsAbleToRemoveAsCost() end
	return Duel.SelectYesNo(tp,aux.Stringid(m,4))
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer(),c:GetReasonEffect())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_REPLACE)
end