--诡秘眼
function c10173068.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)  
	--announce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173068,0))
	e2:SetCategory(CATEGORY_ANNOUNCE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10173068)
	e2:SetCost(c10173068.acost)
	e2:SetOperation(c10173068.aop)
	c:RegisterEffect(e2)
	e2:SetLabel(0)
	--Revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173068,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c10173068.sptg)
	e3:SetOperation(c10173068.spop)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e2)
	--count
	if not c10173068.global_check then
		c10173068.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c10173068.checkop)
		Duel.RegisterEffect(ge1,0)
		ge1:SetLabelObject(e2)
	end
end
function c10173068.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c10173068.cfilter,1,nil,e:GetLabelObject():GetLabel()) then
	   Duel.RegisterFlagEffect(tp,10173068,RESET_PHASE+PHASE_END,0,1)
	   Duel.RegisterFlagEffect(1-tp,10173068,RESET_PHASE+PHASE_END,0,1)
	end
end
function c10173068.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c10173068.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(10173068)>0 and Duel.GetFlagEffect(tp,10173068)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10173068.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10173068.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(0)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10173068.spfilter(c,e,tp,ac)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and c:IsCode(ac)
end
function c10173068.aop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac,c=Duel.AnnounceCard(tp,TYPE_MONSTER),e:GetHandler()
	e:SetLabel(ac)
	e:GetHandler():RegisterFlagEffect(10173068,RESET_EVENT+0x1fe0000,0,0)
	local g=Duel.GetMatchingGroup(c10173068.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp,ac)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10173068,2)) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local tc=g:Select(tp,1,1,nil):GetFirst()
	   if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e1)
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_DISABLE_EFFECT)
		  e2:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e2)
		  Duel.SpecialSummonComplete()
	   end
	end
end