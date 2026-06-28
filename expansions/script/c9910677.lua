--拉尼亚凯亚之凯歌
function c9910677.initial_effect(c)
	--twist spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910677.spcon)
	e1:SetOperation(c9910677.spop)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c9910677.lvtg)
	e2:SetOperation(c9910677.lvop)
	c:RegisterEffect(e2)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e1:SetCondition(c9910677.efcon)
	e1:SetOperation(c9910677.efop)
	c:RegisterEffect(e1)
end
function c9910677.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttack(0) and c:IsDefense(3000)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910677.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local bg=Duel.GetMatchingGroup(c9910677.spfilter,tp,LOCATION_HAND,0,c,e,tp)
	if #bg==0 then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
end
function c9910677.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local bg=Duel.GetMatchingGroup(c9910677.spfilter,tp,LOCATION_HAND,0,c,e,tp)
	if #bg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local bc=bg:Select(tp,1,1,nil):GetFirst()
	sg:AddCard(bc)
	sg:AddCard(c)
end
function c9910677.lvfilter(c,e)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsCanBeEffectTarget(e)
end
function c9910677.fselect(g)
	local lv=g:GetSum(Card.GetLevel)//#g
	return not g:IsExists(Card.IsLevel,1,nil,lv)
end
function c9910677.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(c9910677.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return rg:CheckSubGroup(c9910677.fselect,1,#rg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=rg:SelectSubGroup(tp,c9910677.fselect,false,1,#rg)
	Duel.SetTargetCard(sg)
end
function c9910677.lvopfilter1(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c9910677.lvopfilter2(c,e,lv)
	return not c:IsImmuneToEffect(e) and not c:IsLevel(lv)
end
function c9910677.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(c9910677.lvopfilter1,nil)
	local lv=g:GetSum(Card.GetLevel)//#g
	local tg=g:Filter(c9910677.lvopfilter2,nil,e,lv)
	if #tg==0 then return end
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.AdjustAll()
	if Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910677,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),nil)
	end
end
function c9910677.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c9910677.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(9910677,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910677.rlcon)
	e1:SetTarget(c9910677.rltg)
	e1:SetOperation(c9910677.rlop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c9910677.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9910677.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910677.rlfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsReleasableByEffect()
end
function c9910677.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c9910677.rlfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_RELEASE+REASON_EFFECT)
	end
end
