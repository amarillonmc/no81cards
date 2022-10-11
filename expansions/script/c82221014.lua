local m=82221014
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.actcost)
	c:RegisterEffect(e1)  
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e2)  
	--copy
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))	
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetHintTiming(TIMING_END_PHASE)  
	e3:SetTarget(cm.cptg)  
	e3:SetOperation(cm.cpop)  
	c:RegisterEffect(e3)  
	--act from deck
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(9212051,0)) 
	e4:SetRange(LOCATION_HAND+LOCATION_DECK)
	e4:SetCost(cm.actcost2)
	e4:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(9212051,1)) 
	e5:SetTarget(cm.cptg)  
	e5:SetOperation(cm.cpop)  
	c:RegisterEffect(e5)  
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_DECK)  
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(cm.actarget)
	e5:SetOperation(cm.costop)
	c:RegisterEffect(e5)
end
function cm.cfilter(c)  
	return c:IsSetCard(0xb4) and bit.band(c:GetType(),0x81)==0x81 and not c:IsPublic()  
end  
function cm.actarget(e,te,tp)
	local c=e:GetHandler()
	return te:GetHandler()==c
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then
		return not e:GetHandler():IsLocation(LOCATION_HAND)
	end
end  
function cm.actcost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)  
end  
function cm.cpfilter(c)  
	return bit.band(c:GetType(),0x82)==0x82 and c:IsSetCard(0xb4) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(false,true,false)~=nil  
end  
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then 
		if Duel.GetFlagEffect(tp,82211014)==0 then
			return Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		else
			return Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_HAND,0,1,nil) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		end
	end   
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.GetMatchingGroup(cm.cpfilter,tp,LOCATION_HAND,0,nil)  
	local g2=Duel.GetMatchingGroup(cm.cpfilter,tp,LOCATION_DECK,0,nil)
	if Duel.GetFlagEffect(tp,82211014)==0 then g:Merge(g2) end
	local sg=g:Select(tp,1,1,nil):GetFirst() 
	local te,ceg,cep,cev,cre,cr,crp=sg:CheckActivateEffect(false,true,true)
	if sg:IsLocation(LOCATION_DECK) then
		e:SetLabel(1)
	end
	Duel.SendtoGrave(sg,REASON_COST) 
	e:SetProperty(te:GetProperty())  
	local tg=te:GetTarget()  
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
	te:SetLabelObject(e:GetLabelObject())  
	e:SetLabelObject(te)  
	Duel.ClearOperationInfo(0)  
end  
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local te=e:GetLabelObject()  
	if te then  
		e:SetLabelObject(te:GetLabelObject())  
		local op=te:GetOperation()  
		if op then op(e,tp,eg,ep,ev,re,r,rp) end  
	end  
	if e:GetLabel()==1 then
		Duel.RegisterFlagEffect(tp,82211014,RESET_PHASE+PHASE_END,0,1)
	end
end  