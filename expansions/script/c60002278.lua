--飓风天枪·格里姆尼尔
function c60002278.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to e1
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE) 
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c60002278.ddtg)
	e1:SetOperation(c60002278.ddop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to e3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60002278,1))
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c60002278.spcost)
	e3:SetTarget(c60002278.sptg)
	e3:SetOperation(c60002278.spop)
	c:RegisterEffect(e3)

	--to e4
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c60002278.incon)
	e4:SetValue(800)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e5)
end
--exto e1
function c60002278.bigbaka(c) 
	return c:IsAttackBelow(800) and c:IsFaceup()
end 
function c60002278.zhuzhu(c) 
	return c:IsAttackBelow(2000) and c:IsFaceup()
end
function c60002278.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c60002278.bigbaka,tp,0,LOCATION_MZONE,2,nil) or Duel.IsExistingMatchingCard(c60002278.zhuzhu,tp,0,LOCATION_MZONE,2,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,1-tp,LOCATION_MZONE) 
end  
function c60002278.ddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60002278.bigbaka,tp,0,LOCATION_MZONE,nil)
	local g1=Duel.GetMatchingGroup(c60002278.zhuzhu,tp,0,LOCATION_MZONE,nil)
  if Duel.GetFlagEffect(tp,60002148)<=5 and g:GetCount()>=2  then
		local dg=g:Select(tp,2,2,nil) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then 
			Duel.Damage(1-tp,800,REASON_EFFECT)  
		end 
   elseif Duel.GetFlagEffect(tp,60002148)>=5 and g1:GetCount()>=2 then
		 local xg=g1:Select(tp,2,2,nil) 
		if Duel.Destroy(xg,REASON_EFFECT)~=0 then 
			Duel.Damage(1-tp,2000,REASON_EFFECT)  
		end 
	end 
end 
--exto e3
function c60002278.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x624,2,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x624,2,REASON_COST)
end
function c60002278.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60002278.bigbaka,tp,0,LOCATION_MZONE,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x624)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,1-tp,LOCATION_MZONE) 
end
function c60002278.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60002278.bigbaka,tp,0,LOCATION_MZONE,nil)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>=2 then
		if e:GetHandler():AddCounter(0x624,1)~=0 then
			local dg=g:Select(tp,2,2,nil)
			Duel.Destroy(dg,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,60002148,RESET_PHASE+PHASE_END,0,1000)
		end
	end
end
--exto e4
function c60002278.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
