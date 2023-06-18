--疾 行 机 人 出 击
local m=35399329
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,35399329)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c35399329.target)
	e1:SetOperation(c35399329.activate)
	c:RegisterEffect(e1)
	--shuffle and draw
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,35399329)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c35399329.lvtg)
	e2:SetOperation(c35399329.lvop)
	c:RegisterEffect(e2)
end
function c35399329.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:GetLevel()>0
end
function c35399329.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c35399329.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c35399329.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c35399329.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c35399329.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	lv=Duel.AnnounceLevel(tp,1,7,lv)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetValue(82044279)
			tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_SYNCHRO)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c35399329.thfilter1(c,tp)
	return ((c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO)) or c:IsSetCard(0x2016)) and c:IsAbleToHand() and (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0)
end
function c35399329.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c35399329.thfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c35399329.thfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c35399329.thfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(1),0,0)
end
function c35399329.spfilter1(c,e,tp,dd)
	return c:IsSetCard(0x2016) and c:IsLevelBelow(dd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35399329.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local fg=Group.Filter(Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE),aux.NecroValleyFilter(),nil)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(35399329,1),aux.Stringid(35399329,2))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	end
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local dd=Duel.TossDice(tp,1)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c35399329.spfilter1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,dd) and Duel.SelectYesNo(tp,aux.Stringid(35399329,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c35399329.spfilter1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,dd)
		if tg:GetCount()>0 then
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
		end
		end
	end
	end
end
