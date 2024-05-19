--黄金乡的魔神像
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.setcon)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_NORMAL_TRAP_MONSTER,2000,2800,7,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(95440946)
end
function s.setfilter2(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_NORMAL_TRAP_MONSTER,2000,2800,7,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then
		--atk up
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(s.setfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,s.setfilter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if Duel.SSet(tp,tc)~=0 then
					--Debug.Message("0")
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_CHAINING)
					e2:SetCondition(s.discon)
					e2:SetOperation(s.disop)
					e2:SetLabelObject(tc)
					Duel.RegisterEffect(e2,tp)
					tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_REDIRECT,0,1)
				end
			end
		end
	end
end
function s.atkfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(s.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)*400
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	--Debug.Message("1")
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==tc 
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	--Debug.Message("2")
	if tc:GetFlagEffect(id)>0 then
		--Debug.Message("3")
		local c=e:GetOwner()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(s.distg2)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(s.discon2)
		e2:SetOperation(s.disop2)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(s.distg2)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		Duel.AdjustInstantly()
	end
	e:Reset()
end
function s.distg2(e,c)
	local tc=e:GetLabelObject()
	return c==tc
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler()==tc
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("4")
	Duel.NegateEffect(ev)
end
function s.setfilter(c)
	return c:IsSetCard(0x2142) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
