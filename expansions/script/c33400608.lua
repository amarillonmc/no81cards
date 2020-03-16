--星宫六喰 泳装
local m=33400608
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,4,2)
	c:EnableReviveLimit() 
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.rmcon)
	e0:SetTarget(cm.rmtg)
	e0:SetOperation(cm.rmop)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1,m+10000)
	e1:SetCondition(cm.rmcon1)
	e1:SetTarget(cm.rmtg1)
	e1:SetOperation(cm.rmop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.rmcon2)
	c:RegisterEffect(e2) 
end
function cm.xyzfilter(c)
	return c:IsSetCard(0x341) 
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil) and 
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   if not (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil) and 
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)) then return end 
	if  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
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
				e1:SetLabel(Duel.GetTurnCount())
				Duel.RegisterEffect(e1,tp)
					sc=tr2:GetNext()
			 end
		 end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

function cm.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0
end
function cm.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0
end
function cm.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc1=g:GetFirst()
	Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
	if  Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT)and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then 
		 if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
			Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil) 
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)   
		end
	end
end