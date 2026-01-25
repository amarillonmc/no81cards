--元素百科全书-火之卷
--1200180
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
	
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
end
function s.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return (sc and sc:IsSetCard(0x5240))
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x5240)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x5240) and tc:IsType(TYPE_SYNCHRO) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.studyfilter(c,tp)
	return c:IsCode(1200200) and c.studycon(c,tp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=Duel.GetFlagEffect(tp,id)+1
	local study=Duel.IsExistingMatchingCard(s.studyfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	if count>=2 or study then
	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if count>=3 or study then
		--immune
		local e2=Effect.CreateEffect(c)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(s.efilter)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if count>=4 or study then
		--activate limit
		local e3=Effect.CreateEffect(c)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,1)
		e3:SetCondition(s.condition)
		e3:SetValue(s.aclimit)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
	if count>=5 or study then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
	if count==6 or study then
		--activate cost
		local e41=Effect.CreateEffect(c)
		e41:SetReset(RESET_EVENT+RESETS_STANDARD)
		e41:SetType(EFFECT_TYPE_FIELD)
		e41:SetCode(EFFECT_ACTIVATE_COST)
		e41:SetRange(LOCATION_MZONE)
		e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e41:SetTargetRange(0,1)
		e41:SetCost(s.costchk)
		e41:SetOperation(s.costop)
		c:RegisterEffect(e41)
		--summon cost
		local e43=Effect.CreateEffect(c)
		e43:SetReset(RESET_EVENT+RESETS_STANDARD)
		e43:SetType(EFFECT_TYPE_FIELD)
		e43:SetCode(EFFECT_SUMMON_COST)
		e43:SetRange(LOCATION_MZONE)
		e43:SetTargetRange(0,0xff)
		e43:SetCost(s.costchk)
		e43:SetOperation(s.costop)
		c:RegisterEffect(e43)
		local e44=e43:Clone()
		e44:SetCode(EFFECT_SPSUMMON_COST)
		c:RegisterEffect(e44)
		--accumulate
		local e42=Effect.CreateEffect(c)
		e42:SetReset(RESET_EVENT+RESETS_STANDARD)
		e42:SetType(EFFECT_TYPE_FIELD)
		e42:SetCode(EFFECT_FLAG_EFFECT+id)
		e42:SetRange(LOCATION_MZONE)
		e42:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e42:SetTargetRange(0,1)
		c:RegisterEffect(e42)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
	end
end

function s.tdfilter(c)
	return c:IsSetCard(0x5240) and c:IsAbleToDeck()
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,id)>=4 or Duel.IsExistingMatchingCard(s.studyfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0x3e,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,0x3e)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0x3e,0,aux.ExceptThisCard(e))
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function s.condition(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function s.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,id)
	return Duel.CheckLPCost(tp,ct*300)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,300)
end