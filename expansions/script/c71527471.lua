--诀别世界的血樱
function c71527471.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c71527471.mfilter,1,1)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c71527471.spcost)
	c:RegisterEffect(e0)
	aux.EnableChangeCode(c,71521025,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c71527471.imcon)
	e2:SetValue(c71527471.efilter)
	c:RegisterEffect(e2)
	--cannot release
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCode(EFFECT_UNRELEASABLE_SUM)
	e21:SetCondition(c71527471.imcon)
	e21:SetValue(1)
	c:RegisterEffect(e21)
	--cannot be battle traget
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--tograve and remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c71527471.tgcon)
	e4:SetTarget(c71527471.tgtg)
	e4:SetOperation(c71527471.tgop)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(71527471,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c71527471.tdtg)
	e5:SetOperation(c71527471.tdop)
	c:RegisterEffect(e5)

	Duel.AddCustomActivityCounter(71527471,ACTIVITY_CHAIN,c71527471.chainfilter)
end
function c71527471.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	if rc:IsCode(11110218) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then Duel.RegisterFlagEffect(tp,71527471+1,0,0,1) end
	if rc:IsCode(63086455) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then Duel.RegisterFlagEffect(tp,71527471+2,0,0,1) end
	if rc:IsCode(85698115) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then Duel.RegisterFlagEffect(tp,71527471+3,0,0,1) end
	return true
end
function c71527471.mfilter(c)
	return c:IsCode(71521025)
end
function c71527471.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.GetFlagEffect(tp,71527471+1)>0 and Duel.GetFlagEffect(tp,71527471+2)>0 and Duel.GetFlagEffect(tp,71527471+3)>0
end
function c71527471.imcon(e)
	return e:GetHandler():GetSequence()>4
end
function c71527471.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c71527471.tgfilter(c,tp)
	return c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c71527471.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c71527471.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71527471.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71527471.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c71527471.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c71527471.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local ct2=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c71527471.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		if tc:IsPreviousControler(tp) then ct=ct+1 end
		if tc:IsPreviousControler(1-tp) then ct2=ct2+1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) then
			if rc:IsPreviousControler(tp) then ct=ct+1 end
			if rc:IsPreviousControler(1-tp) then ct2=ct2+1 end
			--自己盖
			local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71527471.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			if ct>0 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71527471,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg1=g1:Select(tp,1,ct,nil)
				local sct=Duel.SSet(tp,sg1)
				ct=ct-sct
			end
			local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71527471.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
			local mzct=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ct>0 and g2:GetCount()>0 and mzct>0 and Duel.SelectYesNo(tp,aux.Stringid(71527471,1)) then
				local sg2=g2:Select(tp,1,math.min(ct,mzct),nil)
				Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEDOWN)
			end
			--对方盖
			local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71527471.setfilter),1-tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			if ct2>0 and g3:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(71527471,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
				local sg3=g3:Select(1-tp,1,ct2,nil)
				local sct2=Duel.SSet(1-tp,sg3)
				ct2=ct2-sct2
			end
			local g4=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71527471.spfilter),1-tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,1-tp)
			local mzct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
			if ct2>0 and g4:GetCount()>0 and mzct2>0 and Duel.SelectYesNo(1-tp,aux.Stringid(71527471,1)) then
				local sg4=g4:Select(1-tp,1,math.min(ct2,mzct2),nil)
				Duel.SpecialSummon(sg4,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
function c71527471.tdfilter(c)
	return c:IsCode(71521025) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c71527471.tdfilter2,tp,0x7e,0x7e,1,c)
end
function c71527471.tdfilter2(c)
	return (c:IsLocation(0x3e) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsAbleToDeck()
end
function c71527471.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x3c) and c71527471.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71527471.tdfilter,tp,0x3c,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c71527471.tdfilter,tp,0x3c,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c71527471.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		local g=Duel.GetMatchingGroup(c71527471.tdfilter2,tp,0x7e,0x7e,c)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end