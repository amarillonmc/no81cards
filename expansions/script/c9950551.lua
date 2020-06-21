--fate·埃尔梅罗二世
function c9950551.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),3)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950551.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950551,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9950551)
	e2:SetCondition(c9950551.spcon)
	e2:SetTarget(c9950551.sptg)
	e2:SetOperation(c9950551.spop)
	c:RegisterEffect(e2)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetCondition(c9950551.effcon)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(4)
	e4:SetCondition(c9950551.actcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetLabel(6)
	e5:SetCondition(c9950551.effcon)
	c:RegisterEffect(e5)
 --spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950551,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99505510)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c9950551.spcon1)
	e1:SetCost(c9950551.spcost1)
	e1:SetTarget(c9950551.sptg1)
	e1:SetOperation(c9950551.spop1)
	c:RegisterEffect(e1)
end
function c9950551.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950551,0))
end
function c9950551.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9950551.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950551.fselect(g,tp)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and g:GetClassCount(Card.GetLevel)==1
		and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,g,2,2)
end
function c9950551.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9950551.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and g:CheckSubGroup(c9950551.fselect,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950551.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950551.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9950551.fselect,false,2,2,tp)
	if sg and sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		tc2:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,sg,2,2)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,sg)
		end
	end
end
function c9950551.effilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950551.effcon(e)
	return Duel.GetMatchingGroupCount(c9950551.effilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>=e:GetLabel()
end
function c9950551.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return c9950551.effcon(e) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9950551.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9950551.rfilter(c,e,tp,mc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba5) and Duel.IsExistingMatchingCard(c9950551.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,mc))
end
function c9950551.spfilter1(c,e,tp,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xba5) and c:IsLevelBelow(8)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c9950551.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroup(tp,c9950551.rfilter,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9950551.rfilter,1,1,c,e,tp,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c9950551.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950551.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950551.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
	end
end