local m=82204232
local cm=_G["c"..m]
cm.name="终焉的时之行者"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,cm.matfilter,2,63,false) 
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeck,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,Duel.SendtoDeck,nil,2,REASON_COST)
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(aux.FALSE)  
	c:RegisterEffect(e0)  
	--negate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)  
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1) 
	--atk/def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(cm.adval)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3) 
end
function cm.matfilter(c)
	return c:IsFusionSetCard(0x5298) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsAbleToRemoveAsCost() end  
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)  
		e1:SetReset(RESET_PHASE+PHASE_END,2)  
		e1:SetCountLimit(1)  
		e1:SetLabel(Duel.GetTurnCount())  
		e1:SetLabelObject(c)  
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)  
		Duel.RegisterEffect(e1,tp)  
	end  
end  
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnCount()>e:GetLabel()  
end  
function cm.retop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.ReturnToField(e:GetLabelObject())  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e2)  
		if tc:IsType(TYPE_TRAPMONSTER) then  
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e3)  
		end  
	end  
end 
function cm.adval(e,c)  
	return Duel.GetTurnCount()*500  
end  