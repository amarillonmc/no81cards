--芳星壳·植园
function c79029581.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029581,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029581)
	e1:SetCondition(c79029581.spcon)
	e1:SetTarget(c79029581.sptg)
	e1:SetOperation(c79029581.spop)
	c:RegisterEffect(e1)	
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c79029581.atkcon)
	e2:SetValue(c79029581.val)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79029581.retg)
	e3:SetOperation(c79029581.reop)
	c:RegisterEffect(e3)
end
function c79029581.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c79029581.val(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)-Duel.GetLP(1-tp)
end
function c79029581.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029581.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c79029581.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c79029581.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		return ct>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c79029581.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
			and Duel.IsExistingMatchingCard(c79029581.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
			and Duel.IsExistingMatchingCard(c79029581.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c79029581.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local zone=c:GetLinkedZone(tp)&0x1f
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		if ct>=3 then
			local g1=Duel.GetMatchingGroup(c79029581.spfilter,tp,LOCATION_HAND,0,nil,e,tp,zone)
			local g2=Duel.GetMatchingGroup(c79029581.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
			local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(c79029581.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,zone)
			if #g1>0 and #g2>0 and #g3>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg2=g2:Select(tp,1,1,nil)
				sg1:Merge(sg2)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg3=g3:Select(tp,1,1,nil)
				sg1:Merge(sg3)
				Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029581.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029581.splimit(e,c)
	return not c:IsSetCard(0xff1) and not c:IsSetCard(0xc9)
end
function c79029581.refil(c,e,tp)
	return c:GetAttack()>0 and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c79029581.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029581.refil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c79029581.refil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g:GetSum(Card.GetAttack))
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetSum(Card.GetAttack))
end
function c79029581.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(d)
	e1:SetValue(c79029581.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	c:SetHint(CHINT_NUMBER,d)  
end
function c79029581.aclimit(e,re,tp)
	local x=e:GetLabel()
	return re:GetHandler():GetAttack()<=x
end











