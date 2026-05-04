--传说之都 亚特兰蒂斯 深层海域
function c88800001.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e2:SetValue(-1)
	c:RegisterEffect(e2)
	--Atk
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--Def
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--recycle
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88800001,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,88800001)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c88800001.condition)
	e5:SetTarget(c88800001.target)
	e5:SetOperation(c88800001.operation)
	c:RegisterEffect(e5)
	--special summon or to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(88800001,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,88800002)
	e6:SetTarget(c88800001.sptg2)
	e6:SetOperation(c88800001.spop2)
	c:RegisterEffect(e6)
end
function c88800001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c88800001.filter(c,tp)
	return c:IsSetCard(0x178) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c88800001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88800001.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c88800001.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c88800001.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c88800001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c88800001.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c88800001.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,22702055)
end
function c88800001.spfilter2(c,e,tp)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,22702055)
end
function c88800001.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g>0 and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c88800001.spfilter1,nil,e,tp)>0) or g:FilterCount(c88800001.spfilter2,nil,e,tp)>0) and Duel.SelectYesNo(tp,aux.Stringid(88800001,2)) then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c88800001.spfilter1,nil,e,tp)>0
		local b2=g:FilterCount(c88800001.spfilter2,nil,e,tp)>0
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(88800001,0),aux.Stringid(88800001,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(88800001,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(88800001,1))+1
		end
		Duel.DisableShuffleCheck()
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:FilterSelect(tp,c88800001.spfilter1,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:FilterSelect(tp,c88800001.spfilter2,1,1,nil,e,tp)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	Duel.ShuffleDeck(tp)
end
