--逆方舟骑士·液氮强弩 温蒂
function c82568000.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x825),1)
	 --plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82568000.pcon)
	e2:SetTarget(c82568000.splimit)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,82568100)
	e1:SetCondition(c82568000.spcondition)
	e1:SetTarget(c82568000.sptarget1)
	e1:SetOperation(c82568000.spop)
	c:RegisterEffect(e1)
	--Water canon Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568000,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c82568000.spcon)
	e3:SetTarget(c82568000.sptg)
	e3:SetOperation(c82568000.spopw)
	c:RegisterEffect(e3)
	--Tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82568000,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCountLimit(2,82568000)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCost(c82568000.mthcost)
	e5:SetTarget(c82568000.mthtarget)
	e5:SetOperation(c82568000.mthoperation)
	c:RegisterEffect(e5)
	--TohandS
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82568000,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCountLimit(2,82568000)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCost(c82568000.mthcost)
	e6:SetTarget(c82568000.sthtarget)
	e6:SetOperation(c82568000.sthoperation)
	c:RegisterEffect(e6)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c82568000.pencon)
	e4:SetTarget(c82568000.pentg)
	e4:SetOperation(c82568000.penop)
	c:RegisterEffect(e4)
end
function c82568000.splimit(e,c,tp,sumtp,sumpos,re)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c82568000.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0 
end
function c82568000.gfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_HAND and c:GetPreviousControler()==tp and c:IsSetCard(0x825)
end
function c82568000.apfilter(c)
	return c:IsFaceup()
end
function c82568000.gravepnfilter(c,csc,apsc,e,tp)
	return (c:GetLevel()>csc and c:GetLevel()<apsc) or (c:GetLevel()<csc and c:GetLevel()>apsc) 
		   and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function c82568000.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82568000.gfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c82568000.apfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) and ep==tp 
end
function c82568000.sptarget1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local scl=math.max(1,e:GetHandler():GetLeftScale()-2)
	local ap=Duel.GetMatchingGroup(c82568000.apfilter,tp,LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	local csc=c:GetLeftScale()
	local apsc=ap:GetLeftScale()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			  and Duel.IsExistingMatchingCard(c82568000.gravepnfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,csc,apsc,e,tp) and e:GetHandler():GetLeftScale()>2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c82568000.spop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local ap=Duel.GetMatchingGroup(c82568000.apfilter,tp,LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	local csc=c:GetLeftScale()
	local apsc=ap:GetLeftScale()
	if not e:GetHandler():IsRelateToEffect(e) 
		  or not Duel.IsExistingMatchingCard(c82568000.apfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568000.gravepnfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,csc,apsc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.BreakEffect()
	 if not c:IsRelateToEffect(e) or c:GetLeftScale()==1 then return end
	local scl=2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(-scl)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
end
function c82568000.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c82568000.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c82568000.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c82568000.WCfilter(c)
	return c:IsCode(82568001) and c:IsFaceup()
end
function c82568000.spcon(e,tp,eg,ep,ev,re,r,rp)
   return not Duel.IsExistingMatchingCard(c82568000.WCfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c82568000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82568001,0,0x4011,1000,900,2,RACE_MACHINE,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82568000.spopw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82568001,0,0x4011,1000,900,2,RACE_MACHINE,ATTRIBUTE_WATER) or not e:GetHandler():IsRelateToEffect(e) then return end
	local token=Duel.CreateToken(tp,82568001)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local g=Duel.GetOperatedGroup()
	local wc=g:GetFirst()
	local code=e:GetHandler():GetOriginalCodeRule()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		wc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		wc:RegisterEffect(e2)
			local cid=wc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
function c82568000.mthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568000.mthtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil end
	local g=Duel.GetAttackTarget()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(c82568000.chlimit)
end
function c82568000.mthoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local g=Group.CreateGroup()
	local c=Duel.GetAttackTarget()
	if c:IsRelateToBattle() then g:AddCard(c) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
	end
end
function c82568000.sfilter(c)
	return c:IsAbleToHand()
end
function c82568000.sthtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568000.sfilter,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c82568000.sfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c82568000.chlimit)
end
function c82568000.sthoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local g=Duel.GetMatchingGroup(c82568000.sfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c82568000.hdtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	Duel.SetChainLimit(c82568000.chlimit)
end
function c82568000.hdoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
function c82568000.chlimit(e,ep,tp)
	return 1-tp==ep
end