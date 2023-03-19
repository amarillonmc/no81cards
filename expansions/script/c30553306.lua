--星辉刻录 时跃
local m=30553306
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+50)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.tgf1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsOnField() and not c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(cm.tgf11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.tgf11(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x308)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.tgf1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.tgf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.tgf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local sc=Duel.SelectMatchingCard(tp,cm.tgf11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	local cc=Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
	if cc and not tc:IsFacedown() and tc:IsRelateToEffect(e) then
		local st=0
		if tc:IsType(TYPE_XYZ) then st=tc:GetRank()
		else st=tc:GetLevel() end
		if sc:GetType()&TYPE_XYZ==TYPE_XYZ then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetValue(st)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			sc:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(st)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			sc:RegisterEffect(e1)
		end
	end
	Duel.SpecialSummonComplete()
end
--e2
function cm.tgf2(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetOverlayCount()>0 and c:IsSetCard(0x308)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.tgf1(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.tgf2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsFacedown() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local co=tc:GetOverlayCount()
		local g=tc:GetOverlayGroup():Select(tp,1,tc:GetOverlayCount(),nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




