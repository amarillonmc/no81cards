local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,4879171)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.pbcost) 
	e1:SetTarget(s.pbtg)
	e1:SetOperation(s.pbop)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.spcon1)
	e2:SetCost(s.pbcost) 
	e2:SetTarget(s.pbtg)
	e2:SetOperation(s.pbop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_FZONE,0)
	e3:SetTarget(s.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(id,2))
	--e4:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE+CATEGORY_DESTROY)
	--e4:SetType(EFFECT_TYPE_QUICK_O)
	--e4:SetCode(EVENT_CHAINING)
	--e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetCountLimit(1,id)
	--e4:SetCondition(s.condition)
	--e4:SetCost(s.spcost)
	--e4:SetTarget(s.thtg)
	--e4:SetOperation(s.thop)
	--c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.discon)
	e4:SetCost(s.discost)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return  not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0xae5d)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.adfilter(c)
	return c:IsSetCard(0xae5d) and c:IsSummonable(true,nil,1)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev)~=0 then
	   Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.costfilter(c,tp)
	return c:IsSetCard(0xae5d) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function s.cfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xae5d)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tc=e:GetLabelObject()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct+1==2 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else e:SetLabel(ct+1) end
	
end
function s.filter1(c)
	return  c:GetFlagEffect(4879171)~=0
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,0x3f,0x3f,1,nil) end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return  not e:GetHandler():IsReason(REASON_DRAW)
end
function s.pbcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function s.pbtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
end
function s.pbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,4)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
  --	  local e2=Effect.CreateEffect(c)
   -- e2:SetType(EFFECT_TYPE_FIELD)
  --  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  --  e2:SetTargetRange(LOCATION_ONFIELD,0)
  --  e2:SetLabel(fid)
  --  e2:SetLabelObject(c)
  --  e2:SetTarget(s.indtg)
 --   e2:SetValue(1)
  --  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_PHASE+PHASE_STANDBY,5)
  --  Duel.RegisterEffect(e2,tp)
  --  e2:SetLabelObject(e1)
   s[c]=e1
	c:RegisterFlagEffect(1082946,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,4,0,nil)
	c:RegisterFlagEffect(4879171,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,4,0,nil)
 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsPublic()
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sfilter(c,e,tp)
	return c:IsSetCard(0xae5d) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and not c:IsCode(id)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ct=e:GetLabel()
	c:SetTurnCounter(ct+1)
	if ct+1==4 then
   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local th=tc:IsAbleToHand()
		local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end

   end
	else e:SetLabel(ct+1) end
end
function s.indtg(e,c)
	return c:IsCode(4879171) and e:GetHandler():IsPublic()
end