local m=82204241
local cm=_G["c"..m]
cm.name="妖狐 虹"
function cm.initial_effect(c)
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetTarget(cm.shtg)  
	e1:SetOperation(cm.shop)  
	c:RegisterEffect(e1)  
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetTarget(cm.reptg)  
	e2:SetValue(cm.repval)  
	e2:SetOperation(cm.repop)  
	c:RegisterEffect(e2)  
end
cm.SetCard_01_YaoHu=true 
function cm.filter(c)  
	return c.SetCard_01_YaoHu and c:IsAbleToHand()  
end  
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.shop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.repfilter1(c,tp)  
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c.SetCard_01_YaoHu  
end  
function cm.repfilter2(c,tp)  
	return c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)  
end  
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.repfilter1,tp,LOCATION_MZONE,0,1,nil) and eg:IsExists(cm.repfilter2,1,nil,tp) end  
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)  
end  
function cm.repval(e,c)  
	return cm.repfilter2(c,e:GetHandlerPlayer())  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)  
end  