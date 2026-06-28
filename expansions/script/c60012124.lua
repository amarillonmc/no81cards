-- 优雅修炼·露
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(s.con1)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.atkcon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3b)
end
s.listed_series={0x5624}
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=c:GetLocation()
	if chk==0 then
		if loc==LOCATION_HAND then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		elseif loc==LOCATION_MZONE then
			return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE,0,1,nil)
		end
		return false
	end
	if loc==LOCATION_HAND then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
end
function s.ctfilter(c)
	return c:IsCanAddCounter(0x624,1)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetLocation()
	if loc==LOCATION_HAND then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif loc==LOCATION_MZONE then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			tc:AddCounter(0x624,1)
			Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		end
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanAddCounter(0x624,1) then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>0
end
