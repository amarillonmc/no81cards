--光堕天使 堕核
local m=40020134
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_XMAT_COUNT_LIMIT)
	--xyz limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_XYZ_MIN_COUNT)
	e1:SetValue(3)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	e3:SetCondition(cm.gfcon)
	c:RegisterEffect(e3)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x86) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.IsExistingMatchingCard(cm.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function cm.spfilter3(c,e,tp,lv)
	return c:IsSetCard(0x86) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and c:IsLevel(lv)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and (not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.BreakEffect()

		local g1=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter3),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(cm.splimit)
	Duel.RegisterEffect(e2,tp)
end

function cm.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function cm.gfcon(e)
	return e:GetHandler():IsCode(49678559) or e:GetHandler():IsCode(67173574)
end
