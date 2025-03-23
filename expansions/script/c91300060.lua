--尸气魔侵染
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetTarget(s.target)  
	e1:SetOperation(s.activate)  
	c:RegisterEffect(e1)  
end
s.Findesiecle=true
function s.afilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(0x10)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	if chk==0 then return g:GetCount()>0 end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,10,0,0)  
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	--local bg=Duel.GetMatchingGroup(s.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e2)
	end
	if sg:GetCount()==1 then
		local tc=sg:GetFirst()
		if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_MUST_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			tc:RegisterEffect(e3)
			Duel.AdjustInstantly()
		end
	end
	if sg:GetCount()==2 then 
		local tc=sg:GetFirst()
		local a=sg:GetFirst()
		local d=sg:GetNext()
		if a:IsAttackable() and not a:IsImmuneToEffect(e) and not d:IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.CalculateDamage(a,d,true)
		end
	end
	if sg:GetCount()>=3 then
		local e1=s.regop(e,tp)
		local res=Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
		if res and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SPSUMMON_COST)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetLabelObject(e1)
				e2:SetOperation(s.resetop)
				tc:RegisterEffect(e2)
				Duel.LinkSummon(tp,tc,nil)
			else
				e1:Reset()
			end
		end
	end  
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
function s.lkfilter(c)
	return c:IsLinkSummonable(nil)
end
function s.regop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.mattg)
	e1:SetValue(s.matval)
	Duel.RegisterEffect(e1,tp)
	return e1
end
function s.mattg(e,c)
	return c:IsRace(0x10)
end
function s.matval(e,lc,mg,c,tp)
	if not (lc:IsRace(0x10) and e:GetHandlerPlayer()==tp) then return false,nil end
	return true,true
end