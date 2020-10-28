--卡西米尔·行动-骑猎竞赛
function c79029341.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029341)
	e1:SetTarget(c79029341.target)
	e1:SetOperation(c79029341.activate)
	c:RegisterEffect(e1)   
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,09029341) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029341.sptg)
	e2:SetOperation(c79029341.spop)
	c:RegisterEffect(e2)
	--
	local e3=e2:Clone()
	e3:SetCondition(c79029341.qocon)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	c:RegisterEffect(e3)
end
function c79029341.tdfil(c)
	return c:GetMaterialCount()>0 and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsPlayerCanDraw(tp,c:GetMaterialCount())
end
function c79029341.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029341.tdfil,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c79029341.tdfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(tc:GetMaterialCount())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,tc:GetMaterialCount())
end
function c79029341.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c79029341.filter1(c,e,tp)
	local zone=Duel.GetLinkedZone(tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x1909) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false,zone) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(c79029341.filter2,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp,lv)
end
function c79029341.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c79029341.filter3,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,99)
end
function c79029341.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c79029341.xxfil(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xa900)
end
function c79029341.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029341.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c79029341.xxfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029341.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c79029341.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c79029341.filter2,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c79029341.filter3,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,99)
		g2:Merge(g3)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP,zone)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029341.splimit)
	Duel.RegisterEffect(e1,tp)
	end
end
function c79029341.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa900) and c:IsLocation(LOCATION_EXTRA)
end
function c79029341.seqfil(c)
	return c:GetSequence()>4
end
function c79029341.qocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and Duel.IsExistingMatchingCard(c79029341.seqfil,tp,LOCATION_MZONE,0,1,nil)
end


