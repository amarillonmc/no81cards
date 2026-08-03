--再临之姬神 艾库莉亚·菲弥琳丝
local s,id=GetID()
function c67200832.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200833)
	e1:SetCost(c67200832.thcon)
	e1:SetTarget(s.pztg)
	e1:SetOperation(s.pzop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.discost)
	--e2:SetTarget(c67200832.destg)
	e2:SetOperation(c67200832.operation)
	c:RegisterEffect(e2)
end
function c67200832.cfilter1(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSummonPlayer(tp)
end
function c67200832.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200832.cfilter1,1,nil,tp)
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
		local mg=Duel.GetRitualMaterial(tp)
		Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,9,"Greater")
		local bool=mg:CheckSubGroup(Auxiliary.RitualCheck,1,1,tp,c,9,"Greater")
		Auxiliary.GCheckAdditional=nil
		return bool
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_PZONE)
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,9,"Greater")
	local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,true,1,1,tp,c,9,"Greater")
	Auxiliary.GCheckAdditional=nil
	if mat and mat:GetCount()>0 then
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
--
function c67200832.filter(c)
	return c:IsType(TYPE_PENDULUM)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and Duel.IsExistingMatchingCard(c67200832.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,c67200832.filter,tp,LOCATION_DECK,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200832.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200832.drcon1)
	e1:SetOperation(c67200832.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67200832.filter1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c67200832.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200832.filter1,1,nil,tp)
		and Duel.IsExistingMatchingCard(c67200832.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c67200832.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c67200832.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200832.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

