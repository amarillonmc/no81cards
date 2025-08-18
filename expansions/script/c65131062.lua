--救世之章 加速
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,s.mfilter,nil,nil,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),1,99)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.cpcon)
	e1:SetCost(s.cpcost)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xff,0)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_TUNER)
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local con=re:GetCondition()
	if not con then con=aux.TRUE end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)	
	if Duel.GetFlagEffect(tp,id)>0 or re:GetCode()==EVENT_SUMMON or re:GetCode()==EVENT_SPSUMMON or re:GetCode()==EVENT_FLIP_SUMMON then return false end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	local res=re:GetHandler()==c and c:IsLocation(loc) and ep==tp and con(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id)
	return res
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cost=re:GetCost()
	if not cost then cost=aux.TRUE end
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	e:SetLabel(re:GetLabel())
	e:SetLabelObject(re:GetLabelObject())
	if chk==0 then return cost(e,tp,eg,ep,ev,re,r,rp,chk) end
	Duel.Hint(HINT_CARD,0,id)
	cost(e,tp,eg,ep,ev,re,r,rp,chk)
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=re:GetTarget()
	if not tg then tg=aux.TRUE end
	if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	if not op then op=aux.TRUE end
	op(e,tp,eg,ep,ev,re,r,rp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if chk==0 then return c:IsReleasable() end
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.Release(c,REASON_COST)
end
function s.spfilter(c,e,tp,sync)
	return c:IsLocation(LOCATION_GRAVE) and c:GetReason()&0x80008==0x80008 and c:GetReasonCard()==sync and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local ct=g:GetCount()
	if chk==0 then return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and ct>0 and Duel.GetMZoneCount(tp,c)>=ct and g:FilterCount(s.spfilter,nil,e,tp,c)==ct and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) end
	g=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local ct=g:GetCount()
	if c:IsSummonType(SUMMON_TYPE_SYNCHRO) and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE) and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) and g:FilterCount(aux.NecroValleyFilter(s.spfilter),nil,e,tp,c)==ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end