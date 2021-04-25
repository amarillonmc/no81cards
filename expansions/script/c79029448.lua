--龙门·行动-飞跃冲刺
function c79029448.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029448)
	e1:SetTarget(c79029448.target)
	e1:SetOperation(c79029448.activate)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19029448)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029448.sptg)
	e2:SetOperation(c79029448.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(79029448,ACTIVITY_SPSUMMON,c79029448.counterfilter)
end
function c79029448.counterfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029448.filter(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_XYZ)
end
function c79029448.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c79029448.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c79029448.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79029448.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79029448.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--
	local e1=Effect.CreateEffect(tc)
	e1:SetDescription(aux.Stringid(79029448,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetTarget(c79029448.skiptg)
	e1:SetOperation(c79029448.skipop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)   
	if not tc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
	end
end
function c79029448.rumfil(c,e,tp,ev)
	local x=math.floor(ev/1000)
	local rk=e:GetHandler():GetRank()
	return c:IsSetCard(0xa900) and c:IsType(TYPE_XYZ) and c:GetRank()>rk and c:IsRankBelow(rk+x) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function c79029448.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029448.rumfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,ev) and ev>=1000 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029448.skipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=math.floor(ev/1000)
	local g=Duel.GetMatchingGroup(c79029448.rumfil,tp,LOCATION_EXTRA,0,nil,e,tp,ev)
	if g:GetCount()<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Overlay(tc,c)
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
end
function c79029448.xfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e)
		and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c79029448.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:IsSetCard(0xa900)
end
function c79029448.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(tc:GetRank())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c79029448.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c79029448.xfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c79029448.xfilter,1,nil,e,tp) and Duel.GetCustomActivityCount(79029448,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c79029448.xfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029448.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c79029448.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029448.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79029448.splimit(e,c)
	return not c:IsSetCard(0xa900)
end











