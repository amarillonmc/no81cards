local m=15000740
local cm=_G["c"..m]
cm.name="升阶魔法-噩梦茧机升格"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c,e,tp)
	local rk=c:GetRank()
	return (rk==2 or rk==3) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
end
function cm.filter2(c,e,tp,mc,rk)
	if c:GetOriginalCode()==6165656 and mc:GetCode()~=48995978 then return false end
	return c:IsRank(rk) and c:IsSetCard(0x6f38) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.desfilter(c)
	return c:IsDestructable() or (c:IsSetCard(0x6f38) and c:IsAbleToHand())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_PZONE)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x6f38) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_PZONE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local ag=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_PZONE,0,1,1,nil)
	if ag:GetFirst():IsSetCard(0x6f38) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
	else
		Duel.Destroy(ag,REASON_EFFECT)
	end
	local bg=Duel.GetOperatedGroup()
	if bg:GetCount()~=0 then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.SendtoGrave(mg,REASON_RULE)
		end
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
			local sc=g:GetFirst()
			if sc then
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
end