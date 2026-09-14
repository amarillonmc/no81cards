--不可见之神·迈达斯业手
function c43990260.initial_effect(c)
	--material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1d3),aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION),true)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(c43990260.condition)
	e0:SetOperation(c43990260.regop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c43990260.splimit)
	c:RegisterEffect(e1)
	--summon process
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se1:SetRange(LOCATION_EXTRA)
	se1:SetCondition(c43990260.sprcon)
	se1:SetTarget(c43990260.sprtg)
	se1:SetOperation(c43990260.sprop)
	se1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(se1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(43990260,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c43990260.sltg)
	e2:SetOperation(c43990260.slop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c43990260.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c43990260.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.GetFlagEffect(sp,43990260)==0
end
function c43990260.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) or c:IsSummonType(SUMMON_VALUE_SELF)
end
function c43990260.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,43990260,RESET_PHASE+PHASE_END,0,1)
end
function c43990260.sprfilter(c,tp)
	return (c:IsRace(RACE_ILLUSION) or c43990260.own(c,tp)) and (c:IsControler(tp) or c:IsFaceup())
end
function c43990260.own(c,tp)
	return c:GetOwner()~=tp
end
function c43990260.matcheck(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and aux.gffcheck(g,Card.IsRace,RACE_ILLUSION,c43990260.own,tp)
end
function c43990260.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c43990260.sprfilter,nil,tp)
	return g:CheckSubGroup(c43990260.matcheck,2,2,tp,c) and Duel.GetFlagEffect(tp,43990260)==0
end
function c43990260.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c43990260.sprfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c43990260.matcheck,false,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c43990260.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c43990260.tsfilter(c,e,tp,chk)
	return c:IsSetCard(0x1d3) and c:IsFaceupEx() and (chk~=2 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() or chk~=1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c43990260.tgcheck(sg,e,tp)
	local g=Duel.GetMatchingGroup(c43990260.tsfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,0)
	return g:CheckSubGroup(c43990260.tscheck,1,#sg,e,tp,sg)
end
function c43990260.tscheck(sg,e,tp,g)
	return sg:FilterCount(c43990260.tsfilter,nil,e,tp,1)==#sg or #sg<=5 and Duel.GetMZoneCount(tp,g)>=#sg and sg:FilterCount(c43990260.tsfilter,nil,e,tp,2)==#sg and (#sg==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
end
function c43990260.tgfilter(c)
	return c:IsSetCard(0x1d3) and c:IsAbleToGrave() and c:IsFaceupEx()
end
function c43990260.mzcheck(sg,tp)
	return Duel.GetMZoneCount(tp,sg,tp,LOCATION_REASON_CONTROL)>0
end
function c43990260.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
	local b1=g1:CheckSubGroup(c43990260.tgcheck,1,#g1,e,tp)
	local g2=Duel.GetMatchingGroup(c43990260.tgfilter,tp,LOCATION_ONFIELD,0,nil)
	local b2=g2:CheckSubGroup(c43990260.mzcheck,1,#g2,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	local g4=Duel.GetMatchingGroup(c43990260.tgfilter,tp,LOCATION_DECK,0,nil)
	local b3=#g3>0 and #g4>0
	if chk==0 then return b1 or b2 or b3 end
end
function c43990260.ctcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==(#sg/2) and #sg%2==0
end
function c43990260.slop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
	local b1=g1:CheckSubGroup(c43990260.tgcheck,1,#g1,e,tp)
	local g2=Duel.GetMatchingGroup(c43990260.tgfilter,tp,LOCATION_ONFIELD,0,nil)
	local b2=g2:CheckSubGroup(c43990260.mzcheck,1,#g2,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	local g4=Duel.GetMatchingGroup(c43990260.tgfilter,tp,LOCATION_DECK,0,nil)
	local b3=#g3>0 and #g4>0
	if not (b1 or b2 or b3) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990260,0)},
		{b2,aux.Stringid(43990260,1)},
		{b3,aux.Stringid(43990260,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g1:SelectSubGroup(tp,c43990260.tgcheck,false,1,#g1,e,tp)
		Duel.HintSelection(tg)
		if Duel.SendtoGrave(tg,REASON_EFFECT)==0 then return end
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		local mg=Duel.GetMatchingGroup(c43990260.tsfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=mg:SelectSubGroup(tp,c43990260.tscheck,false,1,ct,e,tp,nil)
		Duel.HintSelection(sg)
		local s1=sg:FilterCount(c43990260.tsfilter,nil,e,tp,1)==#sg
		local s2=sg:FilterCount(c43990260.tsfilter,nil,e,tp,2)==#sg and Duel.GetMZoneCount(tp)>=#sg and (#sg==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		if s1 and (not s2 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		else
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g2:SelectSubGroup(tp,c43990260.mzcheck,false,1,#g2,tp)
		Duel.HintSelection(tg)
		if Duel.SendtoGrave(tg,REASON_EFFECT)==0 then return end
		local ct=math.min(Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE),(Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.GetControl(sg,tp)
	elseif op==3 then
		local ct=#g3<#g4 and #g3*2 or #g4*2
		g3:Merge(g4)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g3:SelectSubGroup(tp,c43990260.ctcheck,false,2,ct)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c43990260.indtg(e,c)
	local ec=e:GetHandler()
	return c==ec or c==ec:GetBattleTarget()
end
