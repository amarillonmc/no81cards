--神力释放-真祖姿态
function c98500310.initial_effect(c)
	aux.AddCodeList(c,10000000,10000010,10000020)
	aux.EnableChangeCode(c,7373632,LOCATION_MZONE+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500310,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98500310.condition2)
	e1:SetTarget(c98500310.target)
	e1:SetOperation(c98500310.activate)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e4:SetCondition(c98500310.condition)
	c:RegisterEffect(e4)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500310,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98500311)
	e2:SetCondition(c98500310.condition2)
	e2:SetTarget(c98500310.sptg)
	e2:SetOperation(c98500310.spop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e5:SetCondition(c98500310.condition)
	c:RegisterEffect(e5)
	--fusion summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500310,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98500311)
	e3:SetCondition(c98500310.condition2)
	e3:SetTarget(c98500310.fstg)
	e3:SetOperation(c98500310.fsop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e6:SetCondition(c98500310.condition)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(98500310,ACTIVITY_SPSUMMON,c98500310.counterfilter)
end
function c98500310.counterfilter(c)
	return not (c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsSummonLocation(LOCATION_HAND) and c:IsLevel(12))
end
function c98500310.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE)
end
function c98500310.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98500310.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98500310.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98500310.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98500310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98500310,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98500310.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98500310.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsLocation(LOCATION_HAND) and c:IsLevel(12)
end
function c98500310.thfilter(c)
	return c:IsCode(10000000,10000010,10000020) and c:IsAbleToHand()
end
function c98500310.tgfilter(c)
	return c:IsCode(10000000,10000010,10000020) and c:IsAbleToGrave()
end
function c98500310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500310.thfilter,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c98500310.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	local b1=Duel.IsExistingMatchingCard(c98500310.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c98500310.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
   local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(98500310,0)},
		{b2,aux.Stringid(98500310,6)})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	end
end
function c98500310.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local g=Duel.GetMatchingGroup(c98500310.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(c98500310.thfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,nil,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98500310.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98500310.splimit(e,c)
	return not c:IsRace(RACE_DIVINE)
end

function c98500310.spcostfilter1(c)
	return c:IsAbleToDeck() and c:IsLocation(LOCATION_ONFIELD) and c:IsOriginalCodeRule(10000000)
end
function c98500310.spopfilter1(c,e,tp)
	return c:IsCode(98500323) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98500310.spcostfilter2(c,e,tp,tc)
	return c:IsAbleToDeck() and c:IsLocation(LOCATION_ONFIELD) and c:IsOriginalCodeRule(10000010)
end
function c98500310.spopfilter2(c,e,tp)
	return c:IsCode(98500322) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98500310.spcostfilter3(c,e,tp,tc)
	return c:IsAbleToDeck() and c:IsLocation(LOCATION_ONFIELD) and c:IsOriginalCodeRule(10000020)
end
function c98500310.spopfilter3(c,e,tp)
	return c:IsCode(98500324) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98500310.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c98500310.spcostfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c98500310.spopfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp))
	or (Duel.IsExistingMatchingCard(c98500310.spcostfilter2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c98500310.spopfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp))
	or (Duel.IsExistingMatchingCard(c98500310.spcostfilter3,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c98500310.spopfilter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c98500310.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c98500310.spcostfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c98500310.spopfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c98500310.spcostfilter2,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c98500310.spopfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(c98500310.spcostfilter3,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c98500310.spopfilter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(98500310,4)},{b2,aux.Stringid(98500310,5)},{b3,aux.Stringid(98500310,3)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c98500310.spcostfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc2=Duel.SelectMatchingCard(tp,c98500310.spopfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc2,0,tp,tp,true,false,POS_FACEUP)
		tc2:CompleteProcedure()
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g3=Duel.SelectMatchingCard(tp,c98500310.spcostfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoDeck(g3,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc4=Duel.SelectMatchingCard(tp,c98500310.spopfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc4,0,tp,tp,true,false,POS_FACEUP)
		tc4:CompleteProcedure()
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g5=Duel.SelectMatchingCard(tp,c98500310.spcostfilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoDeck(g5,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc6=Duel.SelectMatchingCard(tp,c98500310.spopfilter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc6,0,tp,tp,true,false,POS_FACEUP)
		tc6:CompleteProcedure()
	end
end
function c98500310.fsfilter1(c,e)
	return c:IsRace(RACE_DIVINE) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c98500310.fsfilter2(c,e,tp,m,chkf)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf,true)
end
function c98500310.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(c98500310.fsfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		return Duel.IsExistingMatchingCard(c98500310.fsfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98500310.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(c98500310.fsfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local sg=Duel.GetMatchingGroup(c98500310.fsfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf,true)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
