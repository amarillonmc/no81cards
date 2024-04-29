local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnableExtraDeckSummonCountLimit()
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),2,114,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.setcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	if not s.global_check then
		s.global_check=true
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetLabelObject(sg)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
	end
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)<2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.checkop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(92345028)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION) and aux.ExtraDeckSummonCountLimit[sump]<=0
end
function s.ckfilter(c,tp)
	return c:IsSummonPlayer(tp) and (c:IsPreviousLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION))
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.ckfilter,1,nil,tp) then
		aux.ExtraDeckSummonCountLimit[tp]=aux.ExtraDeckSummonCountLimit[tp]-1
	end
	if eg:IsExists(s.ckfilter,1,nil,1-tp) then
		aux.ExtraDeckSummonCountLimit[1-tp]=aux.ExtraDeckSummonCountLimit[1-tp]-1
	end
end
function s.filter(c)
	return c:GetType()&0x20002==0x20002 and c:GetFlagEffect(id)>0 and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then Duel.SSet(tp,g:GetFirst()) end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,g)
	if #g==0 then return end
	sg:Merge(g)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		local pro1,pro2=te:GetProperty()
		if te:GetCategory()&CATEGORY_FUSION_SUMMON~=0 and pro1&EFFECT_FLAG_UNCOPYABLE==0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(g) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		if #cp>0 then tc:RegisterFlagEffect(id,0,0,0) end
		cp={}
	end
	Card.RegisterEffect=f
	e:Reset()
end
