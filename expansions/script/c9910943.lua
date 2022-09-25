--匪魔追缉者 夜幕审判人
function c9910943.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c9910943.lcheck)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910943)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c9910943.tgtg)
	e2:SetOperation(c9910943.tgop)
	c:RegisterEffect(e2)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910944)
	e2:SetTarget(c9910943.thtg)
	e2:SetOperation(c9910943.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(9910943,ACTIVITY_CHAIN,c9910943.chainfilter)
end
function c9910943.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_TRAP)
end
function c9910943.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3954)
end
function c9910943.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,0)
end
function c9910943.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
end
function c9910943.filter(c,e,tp,ft)
	return c:IsSetCard(0x3954) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)))
end
function c9910943.gselect(g,e,tp,check1,check2)
	local b1=#g==1
	local b2=check1 and g:IsExists(Card.IsAbleToHand,2,nil)
	local b3=check1 and check2
		and g:IsExists(Card.IsCanBeSpecialSummoned,2,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
	return b1 or b2 or b3
end
function c9910943.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9910943.filter,tp,LOCATION_GRAVE,0,nil,e,tp,ft)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c9910943.filter(chkc,e,tp,ft) end
	if chk==0 then return #g>0 end
	local check1=Duel.GetCustomActivityCount(9910943,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(9910943,1-tp,ACTIVITY_CHAIN)~=0
	local check2=ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c9910943.gselect,false,1,2,e,tp,check1,check2)
	Duel.SetTargetCard(tg)
end
function c9910943.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if aux.NecroValleyNegateCheck(tg) then return end
	if tg:GetCount()>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local b1=tg:FilterCount(Card.IsAbleToHand,nil)==#tg
		local ct=tg:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
		local b2=ct==#tg and ft>=ct and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		local opt=-1
		if b1 and not b2 then
			opt=Duel.SelectOption(tp,1190)
		elseif not b1 and b2 then
			opt=Duel.SelectOption(tp,1152)+1
		elseif b1 and b2 then
			opt=Duel.SelectOption(tp,1190,1152)
		end
		if opt==0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		elseif opt==1 then
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
