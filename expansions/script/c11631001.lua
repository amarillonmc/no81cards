--专业药剂师 隆
local m=11631001
local cm=_G["c"..m]
--strings
cm.yaojishi=true 
function cm.initial_effect(c)
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2) 
	--search 2
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)  
	e3:SetCost(cm.cost2)
	e3:SetTarget(cm.tg2)  
	e3:SetOperation(cm.op2)  
	c:RegisterEffect(e3)  
	--activate from hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTarget(cm.actfilter)  
	e4:SetTargetRange(LOCATION_HAND,0)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e5) 
end

--search
function cm.filter(c)  
	return c.zhiyaoshu and c:IsAbleToHand()  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,g)  
	end  
end  

--search 2
function cm.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter2(c)  
	return c.tezhiyao and c:IsAbleToHand()  
end 
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.op2(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
		Duel.ConfirmCards(1-tp,g)  
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc and tc:IsLocation(LOCATION_HAND) then
			Duel.ShuffleHand(tp)
			local e1=Effect.CreateEffect(e:GetHandler())	
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end  
end  

--act in hand
function cm.actfilter(e,c)
	return c.tezhiyao and c:IsPublic()
end
