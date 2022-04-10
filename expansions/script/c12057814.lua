--勇者的奇袭
function c12057814.initial_effect(c)
	 --activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11711438,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)   
	--r and d 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057814,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,12057814)
	e1:SetCondition(c12057814.radcon)
	e1:SetTarget(c12057814.radtg)
	e1:SetOperation(c12057814.radop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057814,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22057814)
	e2:SetCondition(c12057814.setcon)
	e2:SetTarget(c12057814.settg)
	e2:SetOperation(c12057814.setop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12057814,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,32057814)
	e3:SetTarget(c12057814.sptg)
	e3:SetOperation(c12057814.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e4)
end
function c12057814.setfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_WYRM) and c:IsType(TYPE_SYNCHRO) 
end
function c12057814.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12057814.setfilter,1,nil,tp)
end
function c12057814.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c12057814.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SSet(tp,c) 
	end
end
function c12057814.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER,0,0,2,RACE_WYRM,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12057814.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER,0,0,2,RACE_WYRM,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,12057815)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12057814.radfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x145,0x16b)
end
function c12057814.radcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12057814.radfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12057814.radtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1000)
end
function c12057814.radop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil) 
	if g:GetCount()<=0 then return end 
	local dg=g:Select(tp,1,2,nil)   
	if Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)~=0 then
	Duel.BreakEffect() 
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
	end
end








