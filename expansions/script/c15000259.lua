local m=15000259
local cm=_G["c"..m]
cm.name="永寂连接2"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.lcheck)
	c:EnableReviveLimit()
	--back and to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_DECKDES)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.thcon)  
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)
	--get effect  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_XMATERIAL)  
	e2:SetCode(EFFECT_PIERCE)
	e2:SetCondition(cm.atkcon)  
	c:RegisterEffect(e2)
	--adjust  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e3:SetCode(EVENT_ADJUST)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetOperation(cm.adjustop)  
	c:RegisterEffect(e3)
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
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0xaf37) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()  
end  
function cm.th2filter(c)  
	return c:IsSetCard(0xaf37) and c:IsAbleToDeck() 
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.th2filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,cm.th2filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)  
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then  
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then  
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end  
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsSetCard(0xaf37) and e:GetHandler():IsType(TYPE_XYZ) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsSetCard(0xaf37) and c:IsType(TYPE_XYZ)  
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