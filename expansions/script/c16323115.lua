--王·焚世烈焰
function c16323115.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16323115)
	e1:SetCondition(c16323115.condition)
	e1:SetTarget(c16323115.target)
	e1:SetOperation(c16323115.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16323115+1)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16323115.sptg)
	e2:SetOperation(c16323115.spop)
	c:RegisterEffect(e2)
end
function c16323115.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16323115.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16323115.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1)
end
function c16323115.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16323115.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Damage(tp,g:GetFirst():GetBaseAttack(),0x40)
		end
	end
end
function c16323115.cfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&0x1>0 and c:IsSetCard(0x3dcf)
end
function c16323115.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x3dcf)
end
function c16323115.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16323115.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c16323115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2=Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,0x4,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,0x4)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function c16323115.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=0
	local b1=true
	local b2=Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,0x4,1,nil)
	if b1 then
		if not b2 or Duel.SelectYesNo(tp,aux.Stringid(16323115,1)) then
			if Duel.Damage(1-tp,1000,0x40)>0 then
				Duel.BreakEffect()
				Duel.Damage(tp,500,0x40)
			end
			op=1
		end
	end
	b2=Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,0x4,1,nil)
	if b2 and (op==0 or Duel.IsExistingMatchingCard(c16323115.cfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16323115,2))) then
		if op~=0 then
			Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,0,0x4,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if tc and tc:IsCanBeDisabledByEffect(e,false) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
			end
		end
	end
end
function c16323115.dcon(e)
	return Duel.GetAttackTarget()
end