--Card ID is required here, usually defined by the file name in YGOPro
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	Auxiliary.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	--Effect 1: Negate Normal Summon
	--Text: ①：对方把怪兽召唤之际，把自己场上1只怪兽解放才能发动。那次召唤无效，那只怪兽破坏。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)

	--Effect 2: Destroy All & Force Summon
	--Text: ②：1回合1次，对方把怪兽特殊召唤的场合发动。对方场上的怪兽全部破坏。那之后，让对方不用解放进行1只怪兽的召唤。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) -- Mandatory based on text structure
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

--E1 Condition: Opponent's Normal Summon, Chain Link 0
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end

--E1 Cost: Tribute 1 monster
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end

--E1 Target
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end

--E1 Operation
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

--E2 Condition: Opponent Special Summoned
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and Duel.GetCurrentChain()==0
end

--E2 Target
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,1-tp,LOCATION_HAND)
end

--Filter for forced summon: Must be summonable. 
--We pass 'true' to IsSummonable to ignore turn count limits.
function s.sumfilter(c)
	return c:IsSummonable(true,nil)
end

--Filter for the "No Tribute" effect
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0
end

--E2 Operation
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	--Step 1: Destroy all opponent's monsters
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 or Duel.Destroy(g,REASON_EFFECT)==0 then return end
	--Step 2: Force Opponent Normal Summon without Tribute
	--Apply temporary effect to allow summoning without tribute
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(0,LOCATION_HAND) -- Applies to opponent's hand
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(s.ntcon) -- minc=0 (0 tributes)
	e1:SetReset(RESET_CHAIN) -- Resets immediately after resolution
	Duel.RegisterEffect(e1,tp)
	
	--Check if opponent has a summonable monster (now that tributes are 0)
	--Use 1-tp to check opponent's available moves
	if Duel.IsExistingMatchingCard(s.sumfilter,1-tp,LOCATION_HAND,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SUMMON)
		--Opponent selects the card
		local sg=Duel.SelectMatchingCard(1-tp,s.sumfilter,1-tp,LOCATION_HAND,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			--Perform the summon. 
			--Arg 3 (true): Ignore Summon Count (since it's an extra summon)
			--Arg 4 (nil): Standard summon effect
			Duel.Summon(1-tp,tc,true,nil)
		end
	end
end