--育 生 母
local m=22348371
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348371)
	e1:SetCost(c22348371.spcost)
	e1:SetTarget(c22348371.sptg)
	e1:SetOperation(c22348371.spop)
	c:RegisterEffect(e1)
	
end
function c22348371.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22348371.spfilter(c,e,tp)
	local p=c:GetControler()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p) and Duel.GetLocationCount(p,LOCATION_MZONE,tp)>0 and c:IsCanBeEffectTarget(e)
end
function c22348371.tpcheck(g)
	return g:GetClassCount(Card.GetControler)==#g
end
function c22348371.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c22348371.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c22348371.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local aa=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then aa=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c22348371.tpcheck,false,1,aa)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c22348371.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local tc=g:GetFirst()
	while tc do
		local p=tc:GetControler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE,p)>0 then
		Duel.SpecialSummonStep(tc,0,tp,p,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
--		local e2=Effect.CreateEffect(c)
--		e2:SetType(EFFECT_TYPE_SINGLE)
--		e2:SetCode(EFFECT_CANNOT_TRIGGER)
--		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
--		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_UNRELEASABLE_SUM)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e5:SetValue(c22348371.fuslimit)
		tc:RegisterEffect(e5)
		local e6=e3:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e6)
		local e7=e3:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e7)
		local e8=e3:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_DISABLE)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e9)
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_DISABLE_EFFECT)
		e10:SetValue(RESET_TURN_SET)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e10)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c22348371.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
