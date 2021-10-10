--罗德岛·医疗干员-嘉维尔
function c79029109.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.EnableDualAttribute(c)  
	--AD swap 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SWAP_BASE_AD)
	e1:SetCondition(aux.IsDualState)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetCost(c79029109.dscost)
	e2:SetTarget(c79029109.sptg)
	e2:SetOperation(c79029109.spop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c79029109.splimit)
	c:RegisterEffect(e3)
	--coin
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COIN+CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c79029109.cointg)
	e4:SetOperation(c79029109.coinop)
	c:RegisterEffect(e4)
end
function c79029109.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029109.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_COST)
end
function c79029109.filter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsAbleToGrave()
end
function c79029109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029109.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function c79029109.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029109.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	   if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
	local a=tc:GetAttack()
	local b=tc:GetDefense()
	Duel.Recover(tp,a,REASON_EFFECT)
	Duel.Damage(1-tp,b,REASON_EFFECT)
end
end
end
function c79029109.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c79029109.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==0 then
	c:AddCounter(0x1099,3)
	else 
	local x=c:GetCounter(0x1099)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	c:AddCounter(0x1099,x)
	end
end



