--空创拉冬
local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.gravecon)
	e2:SetTarget(s.gravetg)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end

function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,1900,2800,6,RACE_DRAGON,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,1900,2800,6,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end
	
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	
	local b1=false
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
		and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then
		b1=true
	end
	
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local pg=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
		if pg:GetCount()>0 then
			Duel.MoveToField(pg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	

	local ct=Duel.GetMatchingGroupCount(s.HighEvoFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local max_ct=1
	if ct>=6 then max_ct=2 end
	

	local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil)
	
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,max_ct,nil)
		local tc=sg:GetFirst()
		while tc do
			local pre_atk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-2500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			
			if tc:GetAttack()==0 then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
			tc=sg:GetNext()
		end
	end
end

function s.pfilter(c)
	return c:IsCode(40020509) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end

function s.HighEvoFilter(c)
	return s.HighEvo(c)
end

function s.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end

function s.gravecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEDOWN)
		and c:IsReason(REASON_DESTROY)
end

function s.gravetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,1900,2800,6,RACE_DRAGON,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
