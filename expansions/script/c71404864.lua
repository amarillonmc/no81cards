--做梦之少年
c71404864.YumeCost=c71404864.YumeCost or 0
function c71404864.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--selfdes
	local ep1=Effect.CreateEffect(c)
	ep1:SetDescription(aux.Stringid(71404864,2))
	ep1:SetType(EFFECT_TYPE_IGNITION)
	ep1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCountLimit(1,71504865)
	ep1:SetTarget(c71404864.tgp1)
	ep1:SetCost(c71404864.costp1)
	ep1:SetOperation(c71404864.opp1)
	c:RegisterEffect(ep1)
	Duel.AddCustomActivityCounter(71404864,ACTIVITY_NORMALSUMMON,c71404864.counterfilter)
	Duel.AddCustomActivityCounter(71404864,ACTIVITY_SPSUMMON,c71404864.counterfilter)
	--revive limit
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--self special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71404864,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e1:SetCountLimit(1,71404864)
	e1:SetCost(c71404864.cost1)
	e1:SetTarget(c71404864.tg1)
	e1:SetOperation(c71404864.op1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71404864,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71504864)
	e2:SetCost(c71404864.cost2)
	e2:SetCondition(c71404864.con2)
	e2:SetTarget(c71404864.tg2)
	e2:SetOperation(c71404864.op2)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c71404864.atkval)
	c:RegisterEffect(e3)
end
function c71404864.counterfilter(c)
	return c:IsSetCard(0x714)
end
function c71404864.filterp1(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c71404864.costp1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71404864,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(71404864,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71404864.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
end
function c71404864.splimit(e,c)
	return not c:IsSetCard(0x714)
end
function c71404864.tgp1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71404864.filterp1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c71404864.opp1(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71404864.filterp1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c71404864.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if chk==0 then
		local rg=g:Filter(function(c) return c:IsReleasable() or c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_SPELL+TYPE_TRAP) end,nil)
		return g:GetCount()==rg:GetCount() and g:GetCount()>0
	end
	Duel.Release(g,REASON_COST)
end
function c71404864.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0 or c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71404864.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP) then
		c:CompleteProcedure()
		c:RegisterFlagEffect(71404864,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71404864,3))
		Duel.SpecialSummonComplete()
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c71404864.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c71404864.atklimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabel(fid)
		Duel.RegisterEffect(e2,tp)
	end
end
function c71404864.atklimit(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c71404864.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return e:GetLabel()~=tc:GetFieldID() and re:IsActiveType(TYPE_MONSTER) and not tc:IsImmuneToEffect(e)
end
function c71404864.con2(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(71404864)~=0
end
function c71404864.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lpcost=math.floor(Duel.GetLP(tp)/2)
	Duel.PayLPCost(tp,lpcost)
	c71404864.YumeCost=c71404864.YumeCost+lpcost
end
function c71404864.filter2(c,e,sp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x714) and not c:IsCode(71404864) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function c71404864.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		return loc~=0 and Duel.IsExistingMatchingCard(c71404864.filter2,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c71404864.op2(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71404864.filter2,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c71404864.atkval(e,c)
	return c71404864.YumeCost
end