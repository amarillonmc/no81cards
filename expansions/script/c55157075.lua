--冰水结晶
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(s.immfilter)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,id)
	e6:SetCondition(s.remcon)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		Icejade_global_effect={}
		--negate
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(s.discon)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 then
		Icejade_global_effect[re]=true
	end
	return 
end
function s.immfilter(e,c)
	return c:IsSetCard(0x16c) and c:GetFlagEffect(id)==0
end
function s.efilter(e,te,c)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not Icejade_global_effect[te] and c:GetFlagEffect(id)==0 then 
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
	end
	return not Icejade_global_effect[te]
end
function s.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function s.remcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.remfilter,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x16c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(5)
end
function s.syncsumfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x16c) and c:IsSynchroSummonable(nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.AdjustAll()
		local syng=Duel.GetMatchingGroup(s.syncsumfilter,tp,LOCATION_EXTRA,0,nil)
		if #syng>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=Duel.SelectMatchingCard(tp,s.syncsumfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.SynchroSummon(tp,sg1:GetFirst(),nil)
		end
	end
end
