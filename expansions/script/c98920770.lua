--灿幻天龙 穿刺戟龙军王
function c98920770.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()	
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c98920770.sylimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c98920770.sprcon)
	e2:SetTarget(c98920770.sprtg)
	e2:SetOperation(c98920770.sprop)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920770,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920770)
	e2:SetTarget(c98920770.sptg2)
	e2:SetOperation(c98920770.spop2)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920770,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_ATTACK+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,98930770+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c98920770.spcon1)
	e4:SetCost(c98920770.spcost1)
	e4:SetTarget(c98920770.sptg1)
	e4:SetOperation(c98920770.spop1)
	c:RegisterEffect(e4)
	if not c98920770.global_check then
		c98920770.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c98920770.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98920770.sylimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.synlimit(e,se,sp,st)
end
function c98920770.tgrfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost()
end
function c98920770.sfilter1(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_TUNER)
end
function c98920770.sfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost() and not c:IsType(TYPE_TUNER)
end
function c98920770.mnfilter(c,g)
	return g:IsExists(c98920770.mnfilter2,1,c,c)
end
function c98920770.mnfilter2(c,mc)
	return c:GetLevel()+mc:GetLevel()==7
end
function c98920770.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c98920770.sfilter1,1,nil) and g:IsExists(c98920770.sfilter2,1,nil) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c98920770.mnfilter,1,nil,g) and g:GetClassCount(Card.GetLocation)==2
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c98920770.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c98920770.tgrfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(c98920770.fselect,2,2,tp,c)
end
function c98920770.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c98920770.tgrfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c98920770.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c98920770.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	Duel.Remove(tg,POS_FACEUP,REASON_SPSUMMON)
	tg:DeleteGroup()
end
function c98920770.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c98920770.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920770.eqfilter(c,cd)
	return c:IsCode(cd) and (c:IsFaceup() or not c:IsOnField())
end
function c98920770.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c98920770.eqfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c98920770.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920770.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920770.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,98920770,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,98920770,RESET_PHASE+PHASE_END,0,1)
end
function c98920770.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98920770)>=3
end
function c98920770.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920770,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c98920770.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920770.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end