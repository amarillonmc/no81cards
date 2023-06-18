--天璀司的唤死
local m=82209092
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	e0:SetHintTiming(TIMING_REMOVE+TIMING_END_PHASE)  
	c:RegisterEffect(e0)  
	--pos
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SET_POSITION)  
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)  
	e1:SetCondition(cm.poscon)  
	e1:SetTarget(cm.postg)  
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)  
	--must attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(0,LOCATION_MZONE)  
	e2:SetCode(EFFECT_MUST_ATTACK)  
	c:RegisterEffect(e2)  
	--negate  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e3:SetCountLimit(1,m)	
	e3:SetCost(cm.negcost)
	e3:SetTarget(cm.negtg)  
	e3:SetOperation(cm.negop)  
	c:RegisterEffect(e3)  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	Debug.Message(sumpos)
	return (sumpos==POS_FACEUP) 
end  
function cm.poscon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x9298)  
end  
function cm.postg(e,c)  
	return c:IsFaceup()  
end  

--negate
function cm.costfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsSetCard(0x9298) or c:GetControler()~=c:GetOwner())
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x9298) and c:IsType(TYPE_MONSTER)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then  
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
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO) then
			local e4=Effect.CreateEffect(c)  
			e4:SetDescription(aux.Stringid(m,1))
			e4:SetType(EFFECT_TYPE_SINGLE)  
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)  
			e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e4:SetValue(LOCATION_REMOVED)  
			e4:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			tc:RegisterEffect(e4)  
		end
	end  
end  