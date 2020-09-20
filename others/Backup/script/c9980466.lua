--Board·Garren
function c9980466.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980466,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c9980466.spcon)
	e1:SetTarget(c9980466.sptg)
	e1:SetOperation(c9980466.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9980466)
	e1:SetCost(c9980466.cost)
	e1:SetOperation(c9980466.operation)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetOperation(c9980466.sumsuc)
	c:RegisterEffect(e8)
	local e4=e8:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c9980466.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980466,2))
end
function c9980466.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xabca) or c:IsSetCard(0x5bcb)) and not c:IsCode(9980466)
end
function c9980466.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980466.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9980466.filter(c,e,tp)
	return c:IsSetCard(0xabca) and not c:IsCode(9980466) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980466.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980466.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980466.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980466.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9980466.cffilter(c)
	return c:IsRace(RACE_WARRIOR) and not c:IsPublic()
end
function c9980466.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=e:GetLabelObject()
	if pg then pg:DeleteGroup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c9980466.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9980466.cffilter,tp,LOCATION_HAND,0,1,99,e:GetHandler())
	g:KeepAlive()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetCount())
	e:SetLabelObject(g)
end
function c9980466.filter1(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xabca) or c:IsSetCard(0x5bcb))
end
function c9980466.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xabca) or c:IsSetCard(0x5bcb))and c:IsLevelAbove(4)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980466.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Recover(tp,ct*300,REASON_EFFECT)
	local lg=e:GetLabelObject()
	if not lg then return end
	local tg=e:GetLabelObject():Filter(c9980466.filter1,nil)
	local mg=Duel.GetMatchingGroup(c9980466.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	if tg:GetCount()>0 and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9980466,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:Select(tp,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980466,2))
	end
end