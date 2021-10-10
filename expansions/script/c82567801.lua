--方舟骑士·落叶复仇者 守林人
function c82567801.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82567801.pcon)
	e2:SetTarget(c82567801.splimit)
	c:RegisterEffect(e2)  
	--AddCounter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c82567801.indtg)
	e3:SetOperation(c82567801.indop)
	c:RegisterEffect(e3)  
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567801,1))
	e5:SetCategory(CATEGORY_COUNTER+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,82567801)
	e5:SetCondition(c82567801.ctcon)
	e5:SetTarget(c82567801.cttg)
	e5:SetOperation(c82567801.desop)
	c:RegisterEffect(e5)
	--battle indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e7:SetCountLimit(1)
	e7:SetValue(c82567801.valcon)
	c:RegisterEffect(e7)
end
function c82567801.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82567801.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82567801.infilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()  
end
function c82567801.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsSetCard(0x825) and chkc:IsFaceup() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82567801.infilter,tp,LOCATION_MZONE,0,1,nil) end
	local scl=math.min(12,e:GetHandler():GetLeftScale()+1)
	if e:GetHandler():GetLeftScale()<12 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c82567801.infilter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c82567801.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()>=12 then return end
	local scl=1
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_LSCALE)
	e8:SetValue(scl)
	e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e9)
	if tc:IsRelateToEffect(e) 
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0x825) and tc:IsLocation(LOCATION_MZONE)
  then  tc:AddCounter(0x5825,1)
	end
end
function c82567801.costfilter(c)
	return c:IsFaceup()  and c:GetCounter(0x5825)>=2 and c:GetAttack()>0
end
function c82567801.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567801.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
function c82567801.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsSetCard(0x825) and chkc:IsFaceup() and chkc:IsControler(tp) and chkc:GetCounter(0x5825)>=2 and chkc:GetAttack()>0 end
	if chk==0 then return  Duel.IsExistingMatchingCard(c82567801.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c82567801.costfilter,tp,LOCATION_MZONE,0,1,1,nil)   
end
function c82567801.desfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() 
	local atc=tc:GetAttack()
	return c:IsAttackBelow(atc) and c:IsFaceup()
	end
function c82567801.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	local atc=tc:GetAttack()
	if tc:IsCanRemoveCounter(tp,0x5825,2,REASON_COST) then
	tc:RemoveCounter(tp,0x5825,2,REASON_COST) end
	local g=Duel.GetMatchingGroup(c82567801.desfilter,c:GetControler(),0,LOCATION_MZONE,nil,e)
	if g:GetCount()>0 then
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,LOCATION_MZONE)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c82567801.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 and e:GetHandler():IsDefensePos()
end
