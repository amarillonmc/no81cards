--踏雪游龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000196)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFieldID()<=172 then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.handcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.filter1(c)
	return c:IsCode(60000196) and c:IsFaceup() and c:GetCounter(0x62b)~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Debug.Message(Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil))
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil)
		if g and #g>0 and g:GetFirst():RemoveCounter(tp,0x62b,1,REASON_EFFECT) then e:SetLabel(22) end
	else
		e:SetLabel(11)
	end
	
end
function cm.filter2(c)
	return c:IsCode(60000196) and c:IsFaceup() and c:GetCounter(0x62b)<4
end
function cm.zfil(c,zone)
	return c:GetSequence()==zone
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,0,LOCATION_MZONE,1,nil) or Duel.CheckLocation(1-tp,LOCATION_MZONE,0x1) or Duel.IsExistingMatchingCard(cm.zfil,tp,0,LOCATION_MZONE,1,nil,0x1) or Duel.CheckLocation(1-tp,LOCATION_SZONE,0x1) or Duel.IsExistingMatchingCard(cm.zfil,tp,0,LOCATION_SZONE,1,nil,0x1) end
	if e:GetLabel()==22 then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
end
--and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_WYRM,ATTRIBUTE_WIND,POS_FACEUP,1-tp)
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==11 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		if g and #g>0 then g:GetFirst():AddCounter(0x62b,1)  end
	elseif op==22 then 
		local b1=false
		local b2=false
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,0x1) or Duel.IsExistingMatchingCard(cm.zfil,tp,0,LOCATION_MZONE,1,nil,0x1) then b1=true end
		if Duel.CheckLocation(1-tp,LOCATION_SZONE,0x1) or Duel.IsExistingMatchingCard(cm.zfil,tp,0,LOCATION_SZONE,1,nil,0x1) then b2=true end
		if not b1 and not b2 then return end
		local token=Duel.CreateToken(1-tp,m+1)
		local dop=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)})
		if dop==1 then
			if Duel.IsExistingMatchingCard(cm.zfil,tp,0,LOCATION_MZONE,1,nil,0x1) then
				local tg=Duel.GetMatchingGroup(cm.zfil,tp,0,LOCATION_MZONE,nil,0x1)
				if tg then Duel.SendtoGrave(tg,REASON_RULE) end
			end
			if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP,0x1)~=0 then
				--
				local e1=Effect.CreateEffect(c)
				e1:SetCategory(CATEGORY_TOGRAVE)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
				e1:SetCode(EVENT_CHAINING)
				e1:SetRange(LOCATION_MZONE)
				--e1:SetProperty(EFFECT_FLAG_DELAY)
				e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetCondition(cm.mvcon)
				e1:SetOperation(cm.mvop)
				token:RegisterEffect(e1)
			end
		elseif dop==2 then
			if Duel.IsExistingMatchingCard(cm.zfil,tp,0,LOCATION_SZONE,1,nil,0x1) then
				local tg=Duel.GetMatchingGroup(cm.zfil,tp,0,LOCATION_SZONE,nil,0x1)
				if tg then Duel.SendtoGrave(tg,REASON_RULE) end
			end
			if Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,0x1)~=0 then
				local e4=Effect.CreateEffect(c)
				e4:SetCode(EFFECT_CHANGE_TYPE)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e4:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				token:RegisterEffect(e4)
				--
				local e1=Effect.CreateEffect(c)
				e1:SetCategory(CATEGORY_TOGRAVE)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
				e1:SetCode(EVENT_CHAINING)
				e1:SetRange(LOCATION_SZONE)
				--e1:SetProperty(EFFECT_FLAG_DELAY)
				e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetCondition(cm.mvcon)
				e1:SetOperation(cm.mvop)
				token:RegisterEffect(e1)
			end
		end
	end
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
  -- 错误：原条件无法准确判断对方发动的效果
  return rp==1-tp
end

function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local loc = c:IsLocation(LOCATION_MZONE) and LOCATION_MZONE or LOCATION_SZONE
  local seq = c:GetSequence()
  
  -- 检查右侧是否可用
  if seq < 4 then
	local new_seq = seq + 1
	if Duel.CheckLocation(1-tp, loc, new_seq) then
	  Duel.MoveSequence(c, new_seq)
	else
	  Duel.SendtoGrave(c, REASON_RULE)
	  Duel.Draw(1-tp,1,REASON_EFFECT)
	end
  else
	Duel.SendtoGrave(c, REASON_RULE)
	Duel.Draw(1-tp,1,REASON_EFFECT)
  end
end
function cm.filter3(c)
	return c:IsCode(m+1) and c:IsFaceup()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.filter3,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end