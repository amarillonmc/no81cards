--自然色彩 澄苍玉兰
Duel.LoadScript("c33502100.lua")
local m=33502107
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
	BZo_p["Effects"]["c33502107"]=cm.disop
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
	if te==re or not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and re:GetHandler():IsRace(RACE_PLANT)) then return end
	local tep=re:GetHandlerPlayer()
	if not Duel.IsExistingMatchingCard(cm.splimit0,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp)  then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.splimit0,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		local tc=g:GetFirst()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function cm.splimit0(c)
	return c:IsAbleToDeck()
end
--e3
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)<1 then
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_GRAVE,1,1,nil)
	elseif Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)<1 then
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_GRAVE,0,1,1,nil)
	else
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)	
	end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local tep=tc:GetOwner()
  if tc:IsRelateToEffect(e) then
	Duel.MoveToField(tc,tp,tep,LOCATION_SZONE,POS_FACEUP,true)
	if (tc:IsType(TYPE_MONSTER) or tc:IsType(TYPE_TRAP)) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e1)
	if tc:IsType(TYPE_MONSTER) then
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	tc:RegisterEffect(e2)
	else 
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_TRAP)
	tc:RegisterEffect(e2)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.recon)
	e3:SetOperation(cm.repop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e3)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
  end
end
function cm.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SetLP(tp,Duel.GetLP(tp)-200)
	if eg:IsExists(Card.IsRace,1,nil,RACE_PLANT) then
	Duel.Recover(tp,400,REASON_EFFECT)
	end
end