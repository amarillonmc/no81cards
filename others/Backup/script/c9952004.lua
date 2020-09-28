--青眼白龙-三体连接-
function c9952004.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c9952004.spcon)
	e2:SetOperation(c9952004.spop)
	c:RegisterEffect(e2)
 --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
 --extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(2)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9952004.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9952004.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9952004,0))
end
function c9952004.spfilter(c)
	return c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9952004.sumfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9952004.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function c9952004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sum=Duel.GetMatchingGroup(c9952004.sumfilter,tp,LOCATION_MZONE,0,nil):GetSum(c9952004.lv_or_rk)
	if sum>12 then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	if c:IsHasEffect(34822850) then
		if ft>0 then
			return Duel.IsExistingMatchingCard(c9952004.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,c)
		else
			local ct=-ft+1
			return Duel.IsExistingMatchingCard(c9952004.spfilter,tp,LOCATION_MZONE,0,ct,nil)
				and Duel.IsExistingMatchingCard(c9952004.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,c)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c9952004.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,c)
	end
end
function c9952004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(34822850) then
		if ft>0 then
			g=Duel.SelectMatchingCard(tp,c9952004.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,3,c)
		else
			local sg=Duel.GetMatchingGroup(c9952004.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c)
			local ct=-ft+1
			g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
			if ct<3 then
				sg:Sub(g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g2=sg:Select(tp,3-ct,3-ct,nil)
				g:Merge(g2)
			end
		end
	else
		g=Duel.SelectMatchingCard(tp,c9952004.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,3,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end