--星宫六喰 圣诞美人
local m=33400610
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,6,3)
	c:EnableReviveLimit() 
	--to deck
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.rmcon)
	e0:SetTarget(cm.rmtg)
	e0:SetOperation(cm.rmop)
	c:RegisterEffect(e0)
--DISABLE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+10000)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e2) 
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+20000)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.spcon2)
	c:RegisterEffect(e4)
end
function cm.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end

function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return true end
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil)  then return false end  
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	if  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) then 
		 if  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		   local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp,POS_FACEDOWN)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.refilter(c)
	return  c:IsSetCard(0x341)  and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()  
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) and  Duel.GetMatchingGroupCount(nil,1-tp,0,LOCATION_REMOVED,nil)>0  and e:GetHandler():GetFlagEffect(m+90000)==0 end
  e:GetHandler():RegisterFlagEffect(m+90000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,0,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ss=Duel.GetMatchingGroupCount(nil,1-tp,0,LOCATION_REMOVED,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local tg=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,ss,nil)
	 local tc=tg:GetFirst()
	  while tc do  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		 tc=tg:GetNext()
	 end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil) and 
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
 e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil) and 
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)) then return end 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		  local tr1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,nil) 
		  local tr2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		  tr2:Merge(tr1)
		  if  Duel.Remove(tr2,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			 local sc=tr2:GetFirst()
			 while sc do  
				sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				e1:SetLabelObject(sc)
				e1:SetCountLimit(1)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				e1:SetLabel(Duel.GetTurnCount()+1)
				Duel.RegisterEffect(e1,tp)
					sc=tr2:GetNext()
			 end
		 end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil) or
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) 
	then 
		if  Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) then 
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
				Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				local tc2=g2:GetFirst()  
				Duel.Remove(tc2,0,REASON_EFFECT+REASON_TEMPORARY) 
				tc2:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				e1:SetLabelObject(tc2)
				e1:SetCountLimit(1)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				e1:SetLabel(Duel.GetTurnCount()+1)
				Duel.RegisterEffect(e1,tp)
					tc2=g2:GetNext()
			end
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()==e:GetLabel() and tc:GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end