--空创塞壬
local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.pzcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.pztg)
	e2:SetOperation(s.pzop)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

function s.setfilter(c)
	return s.HighEvo(c) and c:IsType(TYPE_TRAP) and not c:IsCode(id) and c:IsSSetable()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_NORMAL+TYPE_TRAP,300,200,1,RACE_WINGEDBEAST,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_NORMAL+TYPE_TRAP,300,200,1,RACE_WINGEDBEAST,ATTRIBUTE_LIGHT) then return end
	
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
		end
	end
end


function s.u_filter(c)

	return c:IsCode(40020509) and c:IsFaceup()
end

function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.u_filter,tp,LOCATION_ONFIELD,0,1,nil)
end

function s.pcfilter(c)
	return c:IsCode(40020509) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())) and not c:IsForbidden()
end

function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then

		local b1 = Duel.CheckLocation(tp,LOCATION_PZONE,0)
		local b2 = Duel.CheckLocation(tp,LOCATION_PZONE,1)
		
		return (b1 or b2)
			and Duel.IsExistingMatchingCard(s.pcfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
	end
end

function s.pzop(e,tp,eg,ep,ev,re,r,rp)

	local b1 = Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local b2 = Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if not b1 and not b2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.pcfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then

		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
