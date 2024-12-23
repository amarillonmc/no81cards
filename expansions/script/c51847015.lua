--幽火军团·涅槃
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--get CONTROL
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.activate1)
	c:RegisterEffect(e2)

end
function s.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and ((c:IsSetCard(0xa67) and c:IsControler(tp)) or (c:IsControler(1-tp) and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_MZONE,0,1,nil)))
	and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 or c:IsAbleToHand())
end
function s.chkfilter(c)
	return c:IsRank(12) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp)
	and ((chkc:IsControler(1-tp)and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_MZONE,0,1,nil)) or chkc:IsControler(tp)) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local thchk=tc:IsAbleToHand()
		local spchk=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
		local which
		if thchk and spchk then
			which=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
		elseif thchk then
			which=0
		elseif spchk then
			which=1
		else
			which=nil
		end
		if which==0 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		elseif which==1 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)and s.filter1(chkc,e,tp)and chkc:IsControler(tp)end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.getfilter,1-tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE+CATEGORY_CONTROL,g,1,0,0)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(s.getfilter,1-tp,LOCATION_MZONE,0,nil,e,tp)
	if tc:IsRelateToEffect(e) then
		if  Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and g then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local gg=g:Select(tp,1,1,nil)
			if not gg then return end
			Duel.GetControl(gg,tp,PHASE_END,1)
		end
	end
end
function s.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xa67)and c:IsControler(tp))and c:IsAbleToGrave()
end
function s.getfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)and c:IsAbleToChangeControler()
end
