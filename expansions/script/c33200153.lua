--种炮连射
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--e1
function s.spfilter(c,e,tp)
	local count=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1041)
	return c:IsSetCard(0x10f3) and c:IsLevelBelow(count)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1041,tc:GetOriginalLevel(),REASON_EFFECT) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--e2
function s.atfilter(c)
	return c:IsSetCard(0x10f3) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackable()
end
function s.filter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsLocation(LOCATION_MZONE)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,1-tp)
	if chk==0 then return g:GetCount()==1 and Duel.IsExistingMatchingCard(s.atfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetCard(g)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsExistingMatchingCard(s.atfilter,tp,LOCATION_MZONE,0,1,nil) and g:GetCount()==1 then
		local ac=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
		local g=Duel.SelectMatchingCard(tp,s.atfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(1)
			e1:SetCondition(s.damcon)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetLabelObject(tc)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			Duel.RegisterEffect(e2,1-tp)
			Duel.CalculateDamage(tc,ac)
		   -- Duel.RaiseEvent(tc,EVENT_BATTLED,nil,REASON_EFFECT,tp,PLAYER_ALL,0)
		   -- Duel.RaiseEvent(re:GetHandler(),EVENT_BATTLED,nil,REASON_EFFECT,tp,PLAYER_ALL,0)
		end
	end
end
function s.damcon(e)
	local tc=e:GetLabelObject()
	return tc==Duel.GetAttacker() or tc==Duel.GetAttackTarget()
end