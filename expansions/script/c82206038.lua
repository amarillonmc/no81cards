local m=82206038
local cm=_G["c"..m]
cm.name="植占师18-骑士"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c) 
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1)
	--tohand(pendulum)  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)
	--special summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_HAND)  
	e3:SetCountLimit(1,82216038)  
	e3:SetCondition(cm.spcon)  
	e3:SetTarget(cm.sptg)  
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3)
	--tohand(monster)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_GRAVE)  
	e4:SetCountLimit(1,82226038)  
	e4:SetCost(cm.thcost2)  
	e4:SetTarget(cm.thtg2)  
	e4:SetOperation(cm.thop2)  
	c:RegisterEffect(e4)  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if c:IsRace(RACE_PLANT) then return false end  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end
function cm.thfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsLevelBelow(4) and not c:IsCode(m)
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end 
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d)  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end  
end
function cm.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end
function cm.thfilter2(c)  
	return c:IsSetCard(0x29d) and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)  
	if #g>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end 