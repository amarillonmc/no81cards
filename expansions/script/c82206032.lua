local m=82206032
local cm=_G["c"..m]
cm.name="植占师12-冰山"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x129d),2,99,true)
	--pierce  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e1) 
	--destroy  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_RECOVER)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)   
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(cm.reccon)  
	e2:SetTarget(cm.rectg)  
	e2:SetOperation(cm.recop)  
	c:RegisterEffect(e2)
	--search  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.thcon)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)  
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)  
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetMaterialCount() 
	if chk==0 then return ct>0 end 
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(ct*500)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)   
end  
function cm.recop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT)  
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)  
end
function cm.thfilter(c)  
	return c:IsSetCard(0x29d) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
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