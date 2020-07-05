local m=82206022
local cm=_G["c"..m]
cm.name="植占师2-双子"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,cm.matfilter,2,true)  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,2))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.tgtg)  
	e1:SetOperation(cm.tgop)  
	c:RegisterEffect(e1) 
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.thcost)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
	--double atk/def 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(m,0)) 
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetCountLimit(1,82216022)
	e3:SetHintTiming(TIMING_DAMAGE_CAL)  
	e3:SetTarget(cm.datg)  
	e3:SetOperation(cm.daop)  
	c:RegisterEffect(e3)  
end
function cm.matfilter(c)  
	return c:IsFusionSetCard(0x129d) and c:IsFusionAttribute(ATTRIBUTE_LIGHT)  
end  
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
end  
function cm.tgfilter1(c,tp)  
	return c:IsSetCard(0x129d) and Duel.IsExistingMatchingCard(cm.tgfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())  
end  
function cm.tgfilter2(c,cd)  
	return c:IsCode(cd) and c:IsAbleToGrave()  
end  
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCode(e:GetLabel()) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter1,tp,LOCATION_GRAVE,0,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,cm.tgfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)  
	e:SetLabel(g:GetFirst():GetCode())  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())  
		if g:GetCount()>0 then  
			Duel.SendtoGrave(g,REASON_EFFECT)  
		end  
	end  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local code=g:GetFirst():GetCode()
	e:SetLabel(code)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
end  
function cm.thfilter1(c,tp)  
	return c:IsSetCard(0x129d) and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and not c:IsPublic()  
end  
function cm.thfilter2(c,cd)  
	return c:IsCode(cd) and c:IsAbleToHand()  
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,code)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.dafilter(c)  
	return c:IsFaceup()
end  
function cm.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.dafilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.dafilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.dafilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function cm.daop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		e1:SetValue(atk*2)  
		tc:RegisterEffect(e1) 
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e3:SetValue(def*2)
		tc:RegisterEffect(e3)
	end  
end  