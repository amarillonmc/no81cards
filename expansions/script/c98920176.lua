--熔岩三炮手
function c98920176.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920176,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,98920176)
	e3:SetCondition(c98920176.thcon)
	e3:SetTarget(c98920176.damtg)
	e3:SetOperation(c98920176.damop)
	c:RegisterEffect(e3)
--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(2)
	c:RegisterEffect(e2)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920176,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98930176)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920176.sptg)
	e2:SetOperation(c98920176.spop)
	c:RegisterEffect(e2)
end
function c98920176.damfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function c98920176.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920176.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920176.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local val=Duel.GetMatchingGroupCount(c98920176.damfilter,tp,LOCATION_GRAVE,0,nil)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c98920176.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val=Duel.GetMatchingGroupCount(c98920176.damfilter,tp,LOCATION_GRAVE,0,nil)*300
	Duel.Damage(p,val,REASON_EFFECT)
end
function c98920176.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function c98920176.gcheck(sg)
	return sg:GetSum(Card.GetLevel)<=8
end
function c98920176.fselect(g,tp,c)
	return g:CheckWithSumEqual(Card.GetLevel,8,g:GetCount(),g:GetCount()) and Duel.GetMZoneCount(tp,c)>=g:GetCount()
end
function c98920176.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920176.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),g:GetCount())
	if chk==0 then
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		aux.GCheckAdditional=c98920176.gcheck
		local res=g:CheckSubGroup(c98920176.fselect,1,ft,tp,e:GetHandler())
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c98920176.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98920176.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),g:GetCount())
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	aux.GCheckAdditional=c98920176.gcheck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c98920176.fselect,false,1,ft,tp,nil)
	aux.GCheckAdditional=nil
	if sg then
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end