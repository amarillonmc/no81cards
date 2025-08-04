--闪蝶幻乐手 桐谷透子
function c9911461.initial_effect(c)
	--spsummon or destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9911461)
	e1:SetTarget(c9911461.stg)
	e1:SetOperation(c9911461.sop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	c9911461.morfonica_summon_effect=e1
	--to hand(self)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9911462)
	e3:SetCondition(c9911461.thcon2)
	e3:SetTarget(c9911461.thtg2)
	e3:SetOperation(c9911461.thop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	--adjust(disablecheck)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(0xff)
	e5:SetLabelObject(e1)
	e5:SetOperation(c9911461.adjustop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetLabelObject(e2)
	c:RegisterEffect(e6)
end
function c9911461.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,9921461)~=0 then
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e1:SetProperty(EFFECT_FLAG_DELAY)
	end
end
function c9911461.spfilter(c,e,tp)
	return c:IsSetCard(0x3952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911461.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:GetColumnGroup():IsExists(Card.IsType,1,nil,TYPE_SPELL+TYPE_TRAP))
end
function c9911461.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c9911461.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		local b2=Duel.IsExistingMatchingCard(c9911461.cfilter,tp,LOCATION_MZONE,0,1,nil)
		return b1 or b2
	end
end
function c9911461.filter(c,i)
	return aux.GetColumn(c)==i
end
function c9911461.desfilter(c,col)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsLocation(LOCATION_FZONE) and bit.band(col,2^aux.GetColumn(c))~=0
end
function c9911461.desfilter2(g)
	for c in aux.Next(g) do
		local cg=Group.__band(c:GetColumnGroup(),g)
		if cg:GetCount()>0 then return false end
	end
	return true
end
function c9911461.sop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911461.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c9911461.cfilter,tp,LOCATION_MZONE,0,1,nil)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911461,0)},{b2,aux.Stringid(9911461,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c9911461.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	elseif op==2 then
		local ct=0
		local col=0
		local g2=Duel.GetMatchingGroup(c9911461.cfilter,tp,LOCATION_MZONE,0,nil)
		for i=0,4 do
			if g2:IsExists(c9911461.filter,1,nil,i) then
				ct=ct+1
				col=col+2^i
			end
		end
		local tg=Duel.GetMatchingGroup(c9911461.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,col)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=tg:SelectSubGroup(tp,c9911461.desfilter2,false,ct,ct)
		if not sg or #sg~=ct then return end
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c9911461.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c9911461.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c9911461.sumfilter(c)
	return c:IsSetCard(0x3952) and c:IsSummonable(true,nil)
end
function c9911461.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(c9911461.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911461,1)) then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9911461.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
