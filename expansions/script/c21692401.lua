--后见灵光 愚者
function c21692401.initial_effect(c) 
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c21692401.splimit)
	c:RegisterEffect(e1)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1) 
	--change effect
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21692401)
	e2:SetCondition(c21692401.chcon) 
	e2:SetTarget(c21692401.chtg)
	e2:SetOperation(c21692401.chop)
	c:RegisterEffect(e2) 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,11692401)
	e3:SetCondition(c21692401.thcon)
	e3:SetTarget(c21692401.thtg)
	e3:SetOperation(c21692401.thop)
	c:RegisterEffect(e3)
end 
c21692401.SetCard_ZW_ShLight=true 
function c21692401.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x555) 
end
function c21692401.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end 
function c21692401.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanSendtoGrave(tp) end
end
function c21692401.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c21692401.repop)
end
function c21692401.repop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,1-tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) then 
		local g=Duel.SelectMatchingCard(1-tp,Card.IsDiscardable,1-tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT) 
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD) 
	end 
end
function c21692401.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c21692401.thfilter(c)
	return c:IsSetCard(0x555) and c:IsAbleToHand()
end
function c21692401.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21692401.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c21692401.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21692401.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT) 
	end
end







