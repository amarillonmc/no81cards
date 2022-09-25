--式神·山兔的迎击战术
local m=96071023
local set=0xff7
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,96071024)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
	--Activate
function cm.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and Duel.IsExistingTarget(cm.setfilter,tp,0,LOCATION_GRAVE,1,nil,c,e,tp)
end
function cm.setfilter(c,cc,e,tp)
	local b1=Duel.GetMZoneCount(1-tp,cc,tp)>0
	local st=Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)
	local b2=st>0 or cc:IsLocation(LOCATION_SZONE) and cc:GetSequence()<5 and st>-1
	return b1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
		or (b2 or c:IsType(TYPE_FIELD)) and c:IsSSetable(true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,cm.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,cm.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,g1:GetFirst(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	if g2:GetFirst():IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=tg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):GetFirst()
	local tc2=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc1 and tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and tc1:IsLocation(LOCATION_GRAVE)
		and tc2 and tc2:IsRelateToEffect(e) then
		if tc2:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			Duel.SSet(tp,tc2,1-tp)
		end
	end
end
	--set
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.exccon(e)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end