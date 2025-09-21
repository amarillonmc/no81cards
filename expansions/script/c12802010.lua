--现梦中之丝绸蚕
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	aux.AddFusionProcFunRep(c,s.matfilter,2,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1193)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.discon)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.immval)
		tc:RegisterEffect(e1)
		if tc:GetFlagEffect(id)>0 then 
			e1:Reset()
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_LEAVE_FIELD_P)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(function(e) return e:GetHandler():GetFlagEffect(id)>0 and e:GetHandler():IsLocation(LOCATION_MZONE) end)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			e:GetHandler():ResetFlagEffect(id)
			e:GetHandler():RegisterFlagEffect(id+o,RESET_CHAIN,0,1)
		end)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EVENT_CHANGE_POS)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e3:SetCondition(function(e) return e:GetHandler():GetFlagEffect(id)>0 and e:GetHandler():IsPreviousPosition(POS_FACEDOWN_DEFENSE) end)
		e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			e:GetHandler():ResetFlagEffect(id)
			e:Reset()
		end)
		tc:RegisterEffect(e3)
	end
end
function s.immval(e,te)
	local c=e:GetHandler()
	local res=te:IsActivated(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=c and te:GetOwner():IsSetCard(0x6a7d)
	if res then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_TOFIELD-RESET_LEAVE,0,1)
	end
	return false
end
function s.matfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsLevelAbove(7)
end
function s.costfilter(c)
	return c:IsRace(RACE_INSECT) and not c:IsLevel(9) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	local sg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and 
	Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	if #tg>0 and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tg:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) 
	and Duel.IsPlayerCanDiscardDeck(tp,1) then
		Duel.BreakEffect()
		Duel.DisableShuffleCheck()
		Duel.DiscardDeck(tp,2,REASON_EFFECT)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_PLAYER)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and (rc:GetFlagEffect(id)>0 or rc:GetFlagEffect(id+o)>0) and p==1-tp
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.NegateEffect(ev)
	if rc:GetFlagEffect(id+o)>0 then
		rc:ResetFlagEffect(id+o)
	end
	if rc:GetFlagEffect(id)>0 and (rc:IsLocation(LOCATION_SZONE) or not rc:IsLocation(LOCATION_MZONE)) then
		rc:ResetFlagEffect(id)
	end
end