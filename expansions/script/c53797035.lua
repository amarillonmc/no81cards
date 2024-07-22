local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(2,id)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetCondition(aux.TRUE)
	c:RegisterEffect(e2)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsLevel(4) and c:IsSetCard(0xac)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0xac) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.filter1(c,ac)
	local le={c:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET)}
	for _,v in pairs(le) do
		local val=v:GetValue() or aux.FALSE
		if (aux.GetValueType(val)=="number" and val==1) or val(v,ac) then return true end
	end
	return false
end
function s.filter2(c,ac)
	return c:GetType()&0x20004==0x20004 and c:IsSetCard(0xac) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local ct2=Duel.GetMatchingGroupCount(s.filter1,tp,0,LOCATION_MZONE,nil,tc)
		local da=not tc:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) and ((ct1==ct2) or tc:IsHasEffect(EFFECT_DIRECT_ATTACK))
		local g=Duel.GetMatchingGroup(Card.IsCanBeBattleTarget,tp,0,LOCATION_MZONE,nil,tc)
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1) end
		local fg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_DECK,0,nil,tp)
		Duel.ResetFlagEffect(tp,id)
		local b1=tc:IsAttackable() and (da or #g>0)
		local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #fg>0
		local op1=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,2)},{b2,aux.Stringid(id,3)},{true,aux.Stringid(id,4)})
		if op1==1 then
			Duel.BreakEffect()
			local op2=aux.SelectFromOptions(tp,{da,1117},{#g>0,aux.Stringid(id,5)})
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetValue(HALF_DAMAGE)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e1,tp)
			if op2==1 then Duel.CalculateDamage(tc,nil,true) elseif op2==2 then
				local bc=g:Select(tp,1,1,nil):GetFirst()
				Duel.CalculateDamage(tc,bc,true)
			end
		elseif op1==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sc=fg:Select(tp,1,1,nil):GetFirst()
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=sc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=sc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
