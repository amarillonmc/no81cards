--键★断片 -  美凪·月 / Frammenti K.E.Y - Minagi -LUNA-
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--lower ATK
	local p1=Effect.CreateEffect(c)
	p1:SetDescription(aux.Stringid(id,0))
	p1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	p1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	p1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	p1:SetRange(LOCATION_PZONE)
	p1:SetCode(EVENT_DAMAGE)
	p1:SetCondition(s.condition)
	p1:SetTarget(s.target)
	p1:SetOperation(s.operation)
	c:RegisterEffect(p1)
	--SS
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.condition)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.damcon)
	e5:SetOperation(s.damop)
	c:RegisterEffect(e5)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>0 and (r&REASON_BATTLE+REASON_EFFECT+REASON_COST)~=0
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(33730033)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33730033,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_PYRO,ATTRIBUTE_WIND) then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	else
		if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,33730033,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_PYRO,ATTRIBUTE_WIND) then
			local token=Duel.CreateToken(tp,33730033)
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKSHF)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end

function s.con(e,tp,eg)
	return eg:IsContains(e:GetHandler())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33730033,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_PYRO,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,33730033)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end

function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==33730033 and c:GetPreviousAttackOnField()>0
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local val=eg:Filter(s.cfilter,nil):GetSum(Card.GetPreviousAttackOnField)
	if val>0 then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Recover(tp,val,REASON_EFFECT)
	end
end