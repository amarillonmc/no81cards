--人理之基 卡利古拉
function c22021540.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021540,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,22021540)
	e1:SetCondition(c22021540.condition)
	e1:SetTarget(c22021540.sptg)
	e1:SetOperation(c22021540.spop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021540,1))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22021541)
	e2:SetTarget(c22021540.cointg)
	e2:SetOperation(c22021540.coinop)
	c:RegisterEffect(e2)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021540,2))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22021541)
	e3:SetCondition(c22021540.erescon)
	e3:SetCost(c22021540.erecost)
	e3:SetTarget(c22021540.cointg)
	e3:SetOperation(c22021540.coinop)
	c:RegisterEffect(e3)
end
c22021540.toss_coin=true
function c22021540.cfilter(c)
	return c:IsFaceup() and c:IsDisabled()
end
function c22021540.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021540.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22021540.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22021540.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22021540.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021540,3))
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c22021540.coinop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c22021540.cfilter,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==0 then
		Duel.SelectOption(tp,aux.Stringid(22021540,4))
	end
	if c1+c2+c3>=1 then
		Duel.SelectOption(tp,aux.Stringid(22021540,5))
		Duel.Recover(tp,900,REASON_EFFECT)
	end
	if c1+c2+c3>=2 then
		Duel.SelectOption(tp,aux.Stringid(22021540,6))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if c1+c2+c3==3 and sg:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22021540,7))
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c22021540.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22021540.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end