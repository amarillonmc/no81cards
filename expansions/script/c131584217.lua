--北极天熊
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	--grave effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.condition)
	e3:SetCost(s.cost)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--release replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(id)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,id+o*10000)
	c:RegisterEffect(e4)
	if not s.Ursarctic_check then
		s.Ursarctic_check=true
		aux.UrsarcticSpSummonCost=s.UrsarcticSpSummonCost
		local rg=Duel.GetMatchingGroup(Card.IsOriginalSetCard,tp,0xff,0xff,nil,0x163)
		for tc in aux.Next(rg) do
			if tc.initial_effect then
				local Ursarctic_initial_effect=s.initial_effect
				s.initial_effect=function() end
				tc:ReplaceEffect(m,0)
				s.initial_effect=Ursarctic_initial_effect
				tc.initial_effect(tc)
			end
		end
	end
end
function s.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function s.mnfilter(c,g)
	return g:IsExists(s.mnfilter2,1,c,c)
end
function s.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1
end
function s.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(s.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(s.fselect,2,2,tp,c)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,s.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x163) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.setfilter(c)
	return c:IsSetCard(0x163) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.rfilter1(c,tp)
	return c:IsLevelAbove(7) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function s.rfilter2(c)
	return c:IsLevelAbove(7) and c:IsReleasable()
end
function s.excostfilter(c,tp)
	return c:IsAbleToRemove() and (c:IsHasEffect(16471775,tp) or c:IsHasEffect(s,tp))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and (Duel.IsExistingMatchingCard(s.rfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
		or (Duel.IsExistingMatchingCard(s.excostfilter,tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.GetLocationCountFromEx(tp)>0))
	local b2=Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
		and (Duel.IsExistingMatchingCard(s.rfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
		or Duel.IsExistingMatchingCard(s.excostfilter,tp,LOCATION_GRAVE,0,1,nil,tp))
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and (b1 or b2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.rfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(s.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return #g1>0 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	local te=tc:IsHasEffect(16471775,tp) or tc:IsHasEffect(89264428,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		aux.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
	end
end
function s.cfilter(c)
	return not c:IsLevelAbove(0) and c:IsFaceup()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		sc:RegisterEffect(e2)
	end
end
function s.excostfilter2(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsHasEffect(31400083,tp) or c:IsHasEffect(id,tp))
end
function s.UrsarcticSpSummonCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Auxiliary.UrsarcticReleaseFilter,e:GetHandler())
	local g2=Duel.GetMatchingGroup(Auxiliary.UrsarcticExCostFilter,tp,LOCATION_GRAVE,0,nil,tp)
	local g3=Duel.GetMatchingGroup(s.excostfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	local te1=tc:IsHasEffect(16471775,tp) or tc:IsHasEffect(89264428,tp)
	local te2=tc:IsHasEffect(31400083,tp) or tc:IsHasEffect(id,tp)
	if te1 then
		te1:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	elseif te2 then
		te2:UseCountLimit(tp)
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Release(tc,REASON_COST)
	end
end
