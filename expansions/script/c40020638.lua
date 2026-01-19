--空创扑翼
local s, id = GetID()
s.named_with_HighEvo = 1

function s.HighEvo(c)
	local m = _G["c" .. c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.leavecon)
	e2:SetTarget(s.tg1)
	e2:SetOperation(s.op1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(s.calccon)
	e3:SetTarget(s.tg2)
	e3:SetOperation(s.op2)
	c:RegisterEffect(e3)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if ac:IsControler(1-tp) then ac,bc=bc,ac end
	return ac:IsControler(tp) and s.HighEvo(ac) and bc:IsControler(1-tp)
end

function s.leavefilter(c,tp)
	return c:IsPreviousControler(tp) and s.HighEvo(c) 
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function s.leavecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.leavefilter,1,nil,tp)
end

function s.calccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end

function s.thfilter(c)
	return (c:IsCode(40020509) or (s.HighEvo(c) and not c:IsCode(id))) 
		and (c:IsAbleToHand() or c:IsAbleToGrave())
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)

	local sg=g:Select(tp,1,1,nil)
	local tc1=sg:GetFirst()

	if g:IsExists(function(c) return not c:IsCode(tc1:GetCode()) end, 1, nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg2=g:FilterSelect(tp, function(c) return not c:IsCode(tc1:GetCode()) end, 1, 1, nil)
		sg:Merge(sg2)
	end
	
	if sg:GetCount()>0 then

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=sg:FilterSelect(tp,Card.IsAbleToHand,0,1,nil)
		if hg:GetCount()>0 then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
			sg:Sub(hg)
		end

		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end

		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			s.do_op2(e,tp)
		end
	end
end

function s.spfilter(c,e,tp)
	return s.HighEvo(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	s.do_op2(e,tp)
end

function s.do_op2(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then

			local a=Duel.GetAttacker()
			local d=Duel.GetAttackTarget()
			if a and d then

				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e1:SetValue(1)
				e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
				a:RegisterEffect(e1)
				
				local e2=e1:Clone()
				d:RegisterEffect(e2)
			end
		end
	end
end
