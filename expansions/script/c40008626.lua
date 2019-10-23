--混沌帝龙-晓光的使者-
function c40008626.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--attribute light
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008626,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c40008626.spcon)
	e3:SetOperation(c40008626.spop)
	e3:SetLabel(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(40008626,1))
	e4:SetLabel(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)  
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008626,2))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c40008626.rmcost)
	e5:SetTarget(c40008626.rmtg)
	e5:SetOperation(c40008626.rmop)
	c:RegisterEffect(e5)
	e3:SetLabelObject(e5)
	e4:SetLabelObject(e5)  
end
function c40008626.spfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function c40008626.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ct>0 and ct==Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c40008626.spfilter,tp,LOCATION_GRAVE,0,ct,nil,e:GetLabel())
end
function c40008626.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c40008626.spfilter,tp,LOCATION_GRAVE,0,nil,e:GetLabel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetLabelObject():SetLabel(e:GetLabel())
end
function c40008626.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.GetCustomActivityCount(40008626,tp,ACTIVITY_CHAIN)==0 and Duel.GetCurrentPhase()==PHASE_MAIN1 end
	Duel.PayLPCost(tp,1000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40008626.damfilter(c,p)
	return c:IsAbleToGrave()
end
function c40008626.filter1(c)
	return c:IsAbleToRemove()
end
function c40008626.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_HAND+LOCATION_ONFIELD) and (chkc:IsAbleToGrave() or chkc:IsAbleToRemove()) end
	if chk==0 then
		if e:GetLabel()==ATTRIBUTE_LIGHT then
			return Duel.IsExistingMatchingCard(c40008626.filter,tp,LOCATION_GRAVE,0,1,nil)
		else
			return true end
	end
	if e:GetLabel()==ATTRIBUTE_LIGHT then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	else
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
	end
end
function c40008626.filter(c)
	return c:IsAbleToHand()
end
function c40008626.sgfilter(c)
	return c:IsLocation(LOCATION_REMOVED)
end
function c40008626.rmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==ATTRIBUTE_LIGHT then
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c40008626.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	else
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,aux.ExceptThisCard(e))
	local ct=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) 
		if ct>0 and g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end
   end
end



