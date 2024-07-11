--羁绊的一等星 完美三角形
function c28341958.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28341958+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28341958.target)
	e1:SetOperation(c28341958.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c28341958.thcon)
	e2:SetTarget(c28341958.thtg)
	e2:SetOperation(c28341958.thop)
	c:RegisterEffect(e2)
	--illumination SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
end
function c28341958.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x284) and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(c28341958.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function c28341958.spfilter(c,e,tp,attr)
	return not c:IsAttribute(attr) and c:IsSetCard(0x284) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c28341958.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28341958.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c28341958.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28341958.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c28341958.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x284) and c:IsLevelAbove(1)
end
function c28341958.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28341958.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local attr=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c28341958.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,attr)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			local cg=Duel.GetMatchingGroup(c28341958.cfilter,tp,LOCATION_MZONE,0,nil)
			if cg:GetClassCount(Card.GetAttribute)>=3 and Duel.IsExistingMatchingCard(c28341958.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28341958,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tg=Duel.SelectMatchingCard(tp,c28341958.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
	end
end
function c28341958.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return eg:IsContains(e:GetHandler()) and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284)
end
function c28341958.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c28341958.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=c:IsRelateToEffect(e)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28341958,0)},
		{b2,aux.Stringid(28341958,1)})
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(c28341958.adcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetOperation(c28341958.adop)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
		table.insert(c28341958.et,{e1})
	else
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c28341958.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28341958.adf,tp,LOCATION_MZONE,0,1,nil,e)
end
function c28341958.adop(e,tp,eg,ep,ev,re,r,rp)
	local c,g= e:GetLabelObject(),Duel.GetMatchingGroup(c28341958.adf,tp,LOCATION_MZONE,0,nil,e)
	for xc in aux.Next(g) do
		local x
		if xc:GetLevel()>0 then x=EFFECT_UPDATE_LEVEL
		elseif xc:GetRank()>0 then x=EFFECT_UPDATE_RANK end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(1)
		e1:SetCondition(c28341958.efcon)
		e1:SetOwnerPlayer(tp)
		xc:RegisterEffect(e1)
		table.insert(c28341958.get(e),xc)
	end
end
function c28341958.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==e:GetOwnerPlayer()
end
c28341958.et = { }
function c28341958.get(v)
	for _,i in ipairs(c28341958.et) do
		if i[1]==v then return i end
	end
end
function c28341958.ck(e,c)
	local t = c28341958.get(e)
	for _,v in ipairs(t) do
		if v == c then return false end
	end
	return true
end
function c28341958.adf(c,e)
	return c:IsSetCard(0x284) and (c:GetLevel()>0 or c:GetRank()>0) and c28341958.ck(e,c)
end
