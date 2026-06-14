--Leukós, the Crystal Magic
local s,id,o=GetID()
function s.initial_effect(c)
	--Effect 1: Quick Effect - banish from hand/field, create lingering LP gain effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.qecost)
	e1:SetTarget(s.qetg)
	e1:SetOperation(s.qeop)
	c:RegisterEffect(e1)
	--Effect 2: If this card in GY would be banished, return to top of Deck instead
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_REMOVE_REDIRECT)
	e2:SetValue(LOCATION_DECK)
	c:RegisterEffect(e2)
	--After redirect to deck, move to top and make face-up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(s.deckop)
	c:RegisterEffect(e3)
	--Effect 3: While face-up on top of Deck, neither player can activate effects in GY
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(s.deckcon)
	e4:SetTargetRange(1,1)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
end
--Effect 1: Quick Effect cost/target/operation
function s.qecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.qetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.qeop(e,tp,eg,ep,ev,re,r,rp)
	--Create lingering trigger that gains LP when cards are banished
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOwnerPlayer(tp)
	e1:SetTarget(s.lptg)
	e1:SetOperation(s.lpop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lp=0
	local tc=eg:GetFirst()
	while tc do
		lp=lp+300
		if tc:IsPreviousLocation(LOCATION_GRAVE) then
			lp=lp+800
		end
		tc=eg:GetNext()
	end
	Duel.SetTargetPlayer(e:GetOwnerPlayer())
	Duel.SetTargetParam(lp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,e:GetOwnerPlayer(),lp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>0 then
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
--Effect 2: GY banish redirect - handled by EFFECT_REMOVE_REDIRECT
--Effect 2b: After arriving in deck, move to top and flip face-up
function s.deckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_DECK) then return end
	Duel.MoveSequence(c,SEQ_DECKTOP)
	c:ReverseInDeck()
end
--Effect 3: Lock GY effects while face-up on top of deck
function s.deckcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_DECK) and c:GetSequence()==0 and c:IsPublic()
end
function s.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
