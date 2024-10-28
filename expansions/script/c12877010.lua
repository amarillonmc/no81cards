--狩猎游戏-恶羚
function c12877010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.EnableReviveLimitPendulumSummonable(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--moster effect
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCountLimit(1,12877010+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c12877010.pspcon)
	e1:SetTarget(c12877010.psptg)
	e1:SetOperation(c12877010.pspop)
	c:RegisterEffect(e1)
	--effect by special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c12877010.condition)
	e2:SetOperation(c12877010.operation)
	c:RegisterEffect(e2)
	--pzone move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12877010,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12877010)
	e3:SetTarget(c12877010.settg)
	e3:SetOperation(c12877010.setop)
	c:RegisterEffect(e3)
	--pendulum effect
	--return to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12877010,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,12877011)
	e4:SetCost(c12877010.thcost)
	e4:SetTarget(c12877010.thtg)
	e4:SetOperation(c12877010.thop)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_PZONE)
	e5:SetOperation(c12877010.chainop)
	c:RegisterEffect(e5)
end
--material(release)
function c12877010.rlfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then val=re:GetValue() end
	return c:IsReleasable(REASON_SPSUMMON) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and (val==nil or val(re,c)~=true))
end
function c12877010.rlcheck(mg,tp)
	return Duel.GetMZoneCount(tp,mg)>0 and (#mg==1 and mg:IsExists(Card.IsLevel,1,nil,10) and mg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) or #mg==2)
end
--material(replace)
function c12877010.rpfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(12877025,tp)
end
--proc
function c12877010.pspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c12877010.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp)
	local rg=Duel.GetMatchingGroup(c12877010.rpfilter,tp,LOCATION_GRAVE,0,nil,tp)
	return (#mg>0 and mg:CheckSubGroup(c12877010.rlcheck,1,2,tp)) or (#rg>0 and Duel.GetMZoneCount(tp)>0)
end
function c12877010.selectcheck(mg,tp)
	return Duel.GetMZoneCount(tp,mg)>0 and (
		(mg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=0
		and mg:IsExists(c12877010.rpfilter,1,nil,tp) and #mg==1)
	or 
		(mg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0
		and (#mg==1 and mg:IsExists(Card.IsLevel,1,nil,10) and mg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) or #mg==2)))
end
function c12877010.psptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c12877010.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp)
	local rg=Duel.GetMatchingGroup(c12877010.rpfilter,tp,LOCATION_GRAVE,0,nil,tp)
	mg:Merge(rg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE) 
	local sg=mg:SelectSubGroup(tp,c12877010.selectcheck,true,1,2,tp)	
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c12877010.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND+LOCATION_ONFIELD) then
		Duel.Release(g,REASON_SPSUMMON)
	else
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_CARD,0,12877025)
	end
	g:DeleteGroup()
end
--effect by special summon rule
function c12877010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function c12877010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12877010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	if c:GetFlagEffect(12877040)==0 then
		e1:SetType(EFFECT_TYPE_IGNITION)
	else
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMING_END_PHASE)
	end
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c12877010.cost)
	e1:SetTarget(c12877010.sctg)
	e1:SetOperation(c12877010.scop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c12877010.costfilter(c)
	return c:IsReleasable() and c:IsSetCard(0x9a7b) and c:IsType(TYPE_MONSTER)
end
function c12877010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12877010.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c12877010.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function c12877010.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x9a7b) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c12877010.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12877010.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12877010.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12877010.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c12877010.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c12877010.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c12877010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c12877010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12877010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function c12877010.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x9a7b) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(c12877010.chainlm)
	end
end
function c12877010.chainlm(e,rp,tp)
	return tp==rp
end
