--璃亚梦黑子制裁之舞
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.con0)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.cost2)
	e3:SetCondition(s.con2)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.prop2)
	c:RegisterEffect(e3)
end


function s.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.checkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x609)
end
function s.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.checkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(0)
	local ad=Group.FromCards(a,d)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,ad) end
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(0)
	local ad=Group.FromCards(a,d)
	local a=Duel.GetAttacker()
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,ad) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,ad)
		if g:GetCount()>0 and a:IsAttackable() and not a:IsImmuneToEffect(e) then
			Duel.CalculateDamage(a,g:GetFirst())

			Duel.BreakEffect()

			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,21000826,0,TYPES_TOKEN_MONSTER,3000,3000,5,RACE_PSYCHO,ATTRIBUTE_EARTH) then return end
			if ft>2 then ft = 2 end
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			for i=1,ft do
				local token=Duel.CreateToken(tp,21000826)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e2:SetTarget(s.efftg)
				e2:SetCondition(aux.TRUE)
				e2:SetValue(aux.tgoval)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e2,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function s.atlimit(e,c)
	return not c:IsCode(21000826)
end
function s.efftg(e,c)
	return not c:IsCode(21000826) and c~=e:GetHandler()
end


function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x609)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.thfilter(c)
	return c:IsSSetable() and c:IsSetCard(0x609) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL))
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21000826,0,TYPES_TOKEN_MONSTER,3000,3000,5,RACE_PSYCHO,ATTRIBUTE_EARTH) end
	local ft=1
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,21000826,0,TYPES_TOKEN_MONSTER,3000,3000,5,RACE_PSYCHO,ATTRIBUTE_EARTH) then return end
	for i=1,1 do
		local token=Duel.CreateToken(tp,21000826)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e2:SetCondition(aux.TRUE)
		e2:SetTarget(s.efftg)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end