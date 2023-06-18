--罗洛瓦-绿流一闪
local m=40011185
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40011177)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.copycon)
	e1:SetTarget(cm.copytg)
	e1:SetOperation(cm.copyop)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.necon)
	e2:SetTarget(cm.netg)
	e2:SetOperation(cm.neop)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsLevel(7) and c:IsLinkCode(40011177) 
end
function cm.copycon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.copyfilter(c,tp)
	return c:IsCode(40011177) and c:GetOriginalType()&TYPE_EFFECT==TYPE_EFFECT 
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.copyfilter(chkc,tp) end
	if chk==0 then return  Duel.IsExistingTarget(cm.copyfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.copyfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g:GetFirst(),1,0,0)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if tc:GetOriginalType()&TYPE_EFFECT==TYPE_EFFECT then
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		end
		if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,40010879,0,TYPES_TOKEN_MONSTER,500,500,1,RACE_PLANT,ATTRIBUTE_EARTH)
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			local ct=1
			if ft>1 then
				local num={}
				local i=1
				while i<=ft do
					num[i]=i
					i=i+1
				end
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
				ct=Duel.AnnounceNumber(tp,table.unpack(num))
			end
			repeat
				local token=Duel.CreateToken(tp,40010879)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_LEAVE_FIELD)
				e2:SetOperation(cm.drop)
				token:RegisterEffect(e2,true)
				ct=ct-1
			until ct==0
			Duel.SpecialSummonComplete()
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA))
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(c:GetPreviousControler(),1,REASON_EFFECT)
	e:Reset()
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(40011177) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		eg:AddCard(e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,2,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end