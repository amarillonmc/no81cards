--幻透翼历战龙
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.hspcon)
	e2:SetTarget(s.hsptg)
	e2:SetOperation(s.hspop)
	c:RegisterEffect(e2)	
	--Negate 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(0)
	if a then
		a:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1)
	end
	if d then
		d:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1)
	end
end
function s.hspfilter(c,tp,sc)
	return c:IsSetCard(0xff) and c:GetFlagEffect(id)>0
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),s.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(s.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():GetFlagEffect(id+1)>0 or Duel.GetFlagEffect(tp,id+1)>0 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.RegisterFlagEffect(tp+1,id,RESET_PHASE|PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		Duel.Hint(HINT_CARD,0,id)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function s.spfilter(c,e,tp)
	if not (c:IsSetCard(0xff) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	if c:IsLocation(LOCATION_DECK) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	elseif c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA|LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA|LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_EXTRA|LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end