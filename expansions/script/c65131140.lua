--秘计螺旋 光辉
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetTarget(s.target)
	e1:SetValue(0x11)
	c:RegisterEffect(e1)
	--time
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.tmcon)
	e2:SetOperation(s.tmop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		local _GetType=Card.GetType
		function Card.GetType(c)
			local re=c:IsHasEffect(id)
			if re then return re:GetLabel() end
			return _GetType(c)
		end
		local _IsType=Card.IsType
		function Card.IsType(c,ctype)
			return Card.GetType(c)&ctype>0
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	c:SetTurnCounter(5)
	c:SetCardData(CARDDATA_LSCALE,5)
	c:SetCardData(CARDDATA_RSCALE,5)
	local e0=Effect.CreateEffect(c)
	e0:SetCode(id)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e0:SetLabel(c:GetType())
	c:RegisterEffect(e0,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_MONSTER+TYPE_PENDULUM)
	c:RegisterEffect(e1,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,5)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,5)
	s[c]=e1
end
function s.fselect(g,g1)
	return g:__band(g1):GetCount()==1
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct-1
	c:SetTurnCounter(ct)
	c:SetCardData(CARDDATA_LSCALE,ct)
	c:SetCardData(CARDDATA_RSCALE,ct)
	if ct==0 then
		if Duel.Destroy(c,REASON_RULE)>0 then
			local g=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_GRAVE,0,nil)
			local count=Duel.GetLocationCount(tp,LOCATION_SZONE)
			if count>g:GetCount() then count=g:GetCount() end
			local g1=g:Filter(Card.IsType,nil,TYPE_FIELD)
			if g1:GetCount()>0 then
				local sg=g:SelectSubGroup(tp,s.fselect,false,count+1,count+1,g1)
				Duel.SSet(tp,sg)
			else
				local sg=g:Select(tp,count,count,nil)
				Duel.SSet(tp,sg)
			end
		end
		e:Reset()
		c:ResetFlagEffect(1082946)
	end
end
function s.tmcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	return ((Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)) or Duel.GetCurrentChain()==0 and ph==PHASE_BATTLE_STEP) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(1082946)~=0
end
function s.tmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) then
		local turne=c[c]
		local op=turne:GetOperation()
		op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
	end
end
function s.spfilter(c)
	return c:IsSpecialSummonable()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonRule(tp,sc)
	end
end