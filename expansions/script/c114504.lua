--里械仪者·风仪弓
local m = 114504
local cm = _G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+100)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)   
end
function cm.pfilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanChangePosition()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c = e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.pfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(cm.pfilter,tp,LOCATION_MZONE,0,1,nil) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g = Duel.SelectTarget(tp,cm.pfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp)
	local tc = Duel.GetFirstTarget()
	local c = e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) > 0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 then
		local spos=0
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
		Duel.SpecialSummon(c,0,tp,tp,false,false,spos)
		if c:IsFacedown() then
			Duel.ConfirmCards(1-tp,c)
		end
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g > 0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end