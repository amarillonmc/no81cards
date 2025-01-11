local m=15000258
local cm=_G["c"..m]
cm.name="永寂连接3"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.lcheck)
	c:EnableReviveLimit()
	--when LinkSummon
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(cm.thcost)
	e1:SetCondition(cm.thcon)  
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)
	--Summon Cost
	--accumulate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FLAG_EFFECT+15000258)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetCondition(cm.costcon)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--adjust  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e5:SetCode(EVENT_ADJUST)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetOperation(cm.adjustop)  
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e6:SetCode(EVENT_TO_GRAVE)  
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(cm.adjust2con)
	e6:SetOperation(cm.adjust2op)  
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e9)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xaf37)
end
function cm.th1filter(c,tp)
	return c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(cm.th2filter,tp,LOCATION_DECK,0,1,nil,c:GetLink())
end
function cm.th2filter(c,lk)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf37) and c:GetLevel()<=lk 
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.th1filter,tp,LOCATION_EXTRA,0,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.th1filter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetLink())
	Duel.SendtoGrave(g,REASON_COST)  
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:IsCostChecked() end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.th2filter,tp,LOCATION_DECK,0,1,1,nil,lk)
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.costcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	return c:IsSetCard(0xaf37) and c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE)
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,15000258)
	return Duel.CheckLPCost(tp,ct*500)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,15000258)
	Duel.PayLPCost(tp,500)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsSetCard(0xaf37) and e:GetHandler():IsType(TYPE_XYZ) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.adjust2con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_OVERLAY)  
end
function cm.adjust2op(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandler():GetControler() 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_XYZ)
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(m)
		tc=g:GetNext()
	end
	Duel.Readjust()
end