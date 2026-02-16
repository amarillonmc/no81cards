--User Created Card
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	Auxiliary.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Special Summon from GY to Turn Player's Field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

function s.spfilter(c,e,tp,targetp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,targetp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local turnp=Duel.GetTurnPlayer()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp,turnp) end
	if chk==0 then return Duel.GetLocationCount(turnp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,turnp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,turnp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local turnp=Duel.GetTurnPlayer()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,turnp,false,false,POS_FACEUP_ATTACK)~=0 then
			local c=e:GetHandler()
			
			--Effect 1: Transfer control once at the end of the Battle Phase
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetOperation(s.ctrlop)
			tc:RegisterEffect(e1)
			
			--Effect 2a: Must attack
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_MUST_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			
			--Effect 2b: Others cannot attack
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetCondition(s.atkcon)
			e3:SetTarget(s.atktg)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			
			--Effect 3: Attack Cost (Release other monster)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ATTACK_COST)
			e4:SetCost(s.atcost)
			e4:SetOperation(s.atop)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
	end
end

--Control Transfer Operation
function s.ctrlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.GetControl(c,1-tp)
	e:Reset() --Ensures it only happens once ("1次")
end

--Condition for "Others cannot attack"
function s.atkcon(e)
	local c=e:GetHandler()
	--Applies only if this card can actually attack
	return c:IsAttackable()
end

--Target for "Others cannot attack"
function s.atktg(e,c)
	return c~=e:GetHandler()
end

--Attack Cost Check
function s.atcost(e,c,tp)
	--Must release 1 OTHER monster
	return Duel.CheckReleaseGroup(tp,nil,1,c)
end

--Attack Cost Operation
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,c)
	Duel.Release(g,REASON_COST)
end