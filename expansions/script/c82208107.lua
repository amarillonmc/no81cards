local m=82208107
local cm=_G["c"..m]
cm.name="调皮宝贝·黑曜石娃"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(cm.matfilter),1)  
	c:EnableReviveLimit()
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)   
	e1:SetCondition(cm.thcon)  
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)  
	--redirect  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e3:SetCondition(cm.recon)  
	e3:SetValue(LOCATION_EXTRA)  
	c:RegisterEffect(e3)  
end
function cm.matfilter(c)  
	return c:IsSetCard(0x120) and not c:IsCode(m)  
end 
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.thfilter(c)  
	return ((c:IsSetCard(0x120) and c:IsType(0x6)) or c:IsCode(24094653)) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end   
function cm.recon(e)  
	return e:GetHandler():IsFaceup()  
end  