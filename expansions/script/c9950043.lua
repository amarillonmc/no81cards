--不死组·辉夜姬
function c9950043.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xba2),aux.FilterBoolFunction(Card.IsFusionSetCard,0xba1),true)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950043)
	e1:SetTarget(c9950043.hsptg)
	e1:SetOperation(c9950043.hspop)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c9950043.sccon)
	e2:SetTarget(c9950043.sctg)
	e2:SetOperation(c9950043.scop)
	c:RegisterEffect(e2)
end
function c9950043.hspfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,113,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9950043.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950043.hspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950043.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950043.hspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,113,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(9950043,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c9950043.retcon)
		e1:SetOperation(c9950043.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9950043.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9950043)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c9950043.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoExtraP(tc,nil,2,REASON_EFFECT)
end
function c9950043.sccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c9950043.mfilter(c)
	return c:IsSetCard(0xba1,0xba2)
end
function c9950043.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c9950043.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950043.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c9950043.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end