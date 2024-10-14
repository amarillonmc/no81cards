--方舟骑士团-维娜·维多利亚
function c29095790.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c29095790.ffilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x87af),3,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29095790,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c29095790.eqtg)
	e1:SetOperation(c29095790.eqop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32710364,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,29095790)
	e2:SetTarget(c29095790.sptg)
	e2:SetOperation(c29095790.spop)
	c:RegisterEffect(e2)
	--Cannot Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c29095790.actcon)
	c:RegisterEffect(e3)
end
--fusion
function c29095790.ffilter(c)
	return c:IsOriginalCodeRule(c,29080482)
end
--e1
function c29095790.eqfilter(c,tp)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)
end
function c29095790.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c29095790.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
end
function c29095790.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c29095790.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,e:GetHandler())
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,4))
	local tc=g1:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c29095790.eqlimit)
		tc:RegisterEffect(e1)
		tc=g1:GetNext()
	end
	Duel.EquipComplete()
end
function c29095790.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--e2
function c29095790.spfilter(c,e,tp)
	return c:GetEquipTarget()==e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29095790.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29095790.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c29095790.rmfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c29095790.refilter(c,tp)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c29095790.rmfilter,1,nil) 
end
function c29095790.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29095790.spfilter,tp,LOCATION_SZONE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
			local g1=Duel.GetMatchingGroup(c29095790.refilter,tp,0,LOCATION_ONFIELD,nil)
				Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--e3
function c29095790.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c29095790.actcon(e,re)
	local tp=e:GetHandlerPlayer()
	local rc=re:GetHandler()
	local b1,eg1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
	local b2,eg2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	local event=(b1 and eg1:IsExists(c29095790.cfilter,1,nil,tp)) or (b2 and eg2:IsExists(c29095790.cfilter,1,nil,tp))
	local ev=Duel.GetCurrentChain()
	local trigger=re:GetType()&(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FLIP)~=0 and (not rc:IsLocation(LOCATION_HAND) or rc:IsPublic())
	return event and (ev==0 or trigger)
end