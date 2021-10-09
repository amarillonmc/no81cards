--自由佣兵的剑士·琪露诺
function c9950037.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950037,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c9950037.destg)
	e2:SetOperation(c9950037.desop)
	c:RegisterEffect(e2)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950037,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9950037.atkcon)
	e1:SetCost(c9950037.atkcost)
	e1:SetOperation(c9950037.atkop)
	c:RegisterEffect(e1)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950037,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c9950037.condition)
	e1:SetTarget(c9950037.target)
	e1:SetOperation(c9950037.operation)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950037.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950037.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950037,0))
end
function c9950037.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c1=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c2=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if (c1>c2 and c2~=0) or c1==0 then c1=c2 end
	if c1~=0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,c1,0,0)
	end
end
function c9950037.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if g1:GetCount()>0 or g2:GetCount()>0 then
		if g1:GetCount()==0 then
			Duel.Destroy(g2,REASON_EFFECT)
		elseif g2:GetCount()==0 then
			Duel.Destroy(g1,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,0)
			local ac=Duel.SelectOption(tp,aux.Stringid(9950037,1),aux.Stringid(9950037,2))
			if ac==0 then Duel.Destroy(g1,REASON_EFFECT)
			else Duel.Destroy(g2,REASON_EFFECT) end
		end
	end
end
function c9950037.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c9950037.atkcfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c9950037.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9950037)==0
		and Duel.IsExistingMatchingCard(c9950037.atkcfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,c) end
	c:RegisterFlagEffect(9950037,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950037.atkcfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950037.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950037,0))
end
function c9950037.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c9950037.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xba1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9950037.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950037.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
