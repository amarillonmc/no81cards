local m=82204240
local cm=_G["c"..m]
cm.name="虚妄灵噬"
function cm.initial_effect(c)
	--negate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)  
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1) 
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetCountLimit(1,m+10000)  
	e2:SetCondition(cm.spcon)  
	e2:SetCost(cm.spcost)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
end
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x6298) 
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e2)  
		if tc:IsType(TYPE_TRAPMONSTER) then  
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e3)  
		end  
	end  
end 
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp
end  
function cm.spfilter(c,e,tp)  
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
		Duel.ConfirmCards(1-tp,tc)
	end   
end  