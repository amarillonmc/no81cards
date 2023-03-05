--苍星之集灵者
local m=33332009
local cm=_G["c"..m]
function c33332009.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
   --remove and Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,m+50)
	e3:SetCondition(cm.negcon)
	e3:SetCost(cm.negcost)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetRange(LOCATION_MZONE) 
	e2:SetOperation(cm.negop2)
	c:RegisterEffect(e2)
end
--special summon
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5567) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
--removeand destroy
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp
		and re:IsActiveType(TYPE_MONSTER) 
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.rmfilter(c,e,tp)
	return c:IsSetCard(0x5567) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_DECK,0,nil,e,tp)
	return g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)~=0 then
		  local og=Duel.GetOperatedGroup()
		  local tc=og:GetFirst() 
		  while tc do 
		  tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		  tc=og:GetNext() 
		  end 
		  og:KeepAlive()
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		  e2:SetCountLimit(1)
		  e2:SetLabel(Duel.GetTurnCount())
		  e2:SetLabelObject(og)
		  e2:SetCondition(cm.retcon)
		  e2:SetOperation(cm.retop)
		  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		  Duel.RegisterEffect(e2,tp)
		end
	end
end 
function cm.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)~=0 then
		  local og=Duel.GetOperatedGroup()
		  local tc=og:GetFirst() 
		  while tc do 
		  tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		  tc=og:GetNext() 
		  end 
		  og:KeepAlive()
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		  e2:SetCountLimit(1)
		  e2:SetLabel(Duel.GetTurnCount())
		  e2:SetLabelObject(og)
		  e2:SetCondition(cm.retcon)
		  e2:SetOperation(cm.retop)
		  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		  Duel.RegisterEffect(e2,tp)
			if re:GetHandler():IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.Destroy(eg,REASON_EFFECT)
			end   
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function cm.xretfil(c) 
	return c:GetFlagEffect(m)~=0 and c:IsAbleToHand()  
end 
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject() 
	local sg=g:Filter(cm.xretfil,nil) 
	if sg:GetCount()>0 then 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end 
end
