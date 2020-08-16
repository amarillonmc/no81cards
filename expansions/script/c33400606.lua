--星宫六喰 坠落之星
local m=33400606
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2) 
--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m+10000)
	e5:SetCondition(cm.con1)
	e5:SetTarget(cm.retg)
	e5:SetOperation(cm.reop)
	c:RegisterEffect(e5)
	local e51=Effect.CreateEffect(c)
	e51:SetCategory(CATEGORY_REMOVE)
	e51:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e51:SetCode(EVENT_SPSUMMON_SUCCESS)
	e51:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e51:SetCountLimit(1,m+10000)
	e51:SetTarget(cm.retg)
	e51:SetOperation(cm.reop)
	c:RegisterEffect(e51)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0   end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)  
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end   
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,c:IsCode(m)) then 
		if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		 local tr=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,c:IsCode(m)) 
		 tc=tr:GetFirst()
			if  Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 then 
				local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e1:SetLabelObject(tc)
					e1:SetCountLimit(1)
					if Duel.GetCurrentPhase()==PHASE_STANDBY then
						e1:SetLabel(Duel.GetTurnCount())
						e1:SetCondition(cm.retcon)
						e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
					else
						e1:SetReset(RESET_PHASE+PHASE_STANDBY)
					end
					e1:SetOperation(cm.retop)
					Duel.RegisterEffect(e1,tp)
			end
		end
	end   
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsType(TYPE_FIELD) and tc:IsPreviousLocation(LOCATION_FZONE) then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	elseif tc:IsType(TYPE_PENDULUM) and tc:IsPreviousLocation(LOCATION_PZONE) then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else
		Duel.ReturnToField(e:GetLabelObject())
	end
	Duel.ReturnToField(tc) 
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x341) ) 
end
function cm.thfilter1(c)
	return c:IsSetCard(0x9342,0xc342) and c:IsType(TYPE_SPELL,TYPE_TRAP) and c:IsAbleToHand()
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then 
		if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then   
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tr=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil) 
		  Duel.Remove(tr,POS_FACEUP,REASON_EFFECT)
		end
	end  
end