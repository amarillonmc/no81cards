--逆方舟骑士·暴君 塔露拉
function c82568007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x825),10,3)
	c:EnableReviveLimit()
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c82568007.discon)
	e2:SetCost(c82568007.discost)
	e2:SetTarget(c82568007.distg)
	e2:SetOperation(c82568007.disop)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568007,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,82568007)
	e3:SetCost(c82568007.adcost)
	e3:SetTarget(c82568007.adtg)
	e3:SetOperation(c82568007.adop)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
   --summon success
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c82568007.addcon)
	e4:SetTarget(c82568007.addct)
	e4:SetOperation(c82568007.addc)
	c:RegisterEffect(e4)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c82568007.pencon)
	e5:SetTarget(c82568007.pentg)
	e5:SetOperation(c82568007.penop)
	c:RegisterEffect(e5)
	--meteor rain
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82568007,1))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE+CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTarget(c82568007.mrtg)
	e6:SetCost(c82568007.mrcost)
	e6:SetOperation(c82568007.mrop)
	c:RegisterEffect(e6)
	--Revive
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82568007,2))
	e7:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c82568007.sumcon)
	e7:SetTarget(c82568007.sumtg)
	e7:SetOperation(c82568007.sumop)
	c:RegisterEffect(e7)
	--rage flame
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c82568007.tgcon)
	e8:SetTarget(c82568007.tgtg)
	e8:SetOperation(c82568007.tgop)
	c:RegisterEffect(e8)
end
function c82568007.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) 
end
function c82568007.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c82568007.sprfilter(c)
	return (c:IsXyzType(TYPE_XYZ) or c:IsXyzType(TYPE_FUSION) or c:IsXyzType(TYPE_SYNCHRO) or c:IsXyzType(TYPE_RITUAL) or c:GetLink()>=2 ) and c:IsSetCard(0x825) and
			 c:IsFaceup()
end
function c82568007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c82568007.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>2
end
function c82568007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c82568007.sprfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568007,4))
		g=mg:Select(tp,3,3,nil)
	end
				   local sg=Group.CreateGroup()
						local tc=g:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=g:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
	e:GetHandler():SetMaterial(g)
	 Duel.Overlay(e:GetHandler(),g)
end
function c82568007.ctfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_MONSTER)
end
function c82568007.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation(LOCATION_EXTRA)
end
function c82568007.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x5824)
end
function c82568007.addc(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c82568007.ctfilter,tp,LOCATION_GRAVE,0,nil)
	local xm=e:GetHandler():GetOverlayCount()
	local ct1=ct+xm
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x5824,ct1)
	end
end
function c82568007.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c82568007.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5824,2,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5824,2,REASON_COST)
end
function c82568007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c82568007.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c82568007.adfilter(c)
	return c:IsFaceup() 
end
function c82568007.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5824,1,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5824,1,REASON_COST)
end
function c82568007.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()  end
	if chk==0 then return Duel.IsExistingTarget(c82568007.adfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568007.adfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5823,1)
end
function c82568007.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
  then  tc:AddCounter(0x5823,1)
	end
end
function c82568007.tgfilter(c)
	return c:IsFaceup() and c:GetCounter(0x5823)>0
end
function c82568007.tgfilter2(c,s)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 
end
function c82568007.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c82568007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568007.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c82568007.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c82568007.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(c82568007.tgfilter,tp,0,LOCATION_MZONE,nil)
	if c:IsRelateToEffect(e)  then
		local g=Duel.GetMatchingGroup(c82568007.tgfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		while tc do
		local seq=tc:GetSequence()
		local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(c82568007.tgfilter2,tp,0,LOCATION_ONFIELD,nil,seq) end
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and dg:GetCount()>0 then
			Duel.SendtoGrave(dg,REASON_EFFECT)
		tc=g:GetNext()
		end
		end
	end
end
function c82568007.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
			   and (c:GetOverlayCount()>0 or c:IsSummonType(TYPE_RITUAL))
end
function c82568007.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c82568007.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c82568007.atkfilter(c)
	return c:IsFaceup() 
end
function c82568007.mrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568007.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c82568007.mrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	e:GetHandler():RegisterFlagEffect(82568007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c82568007.desfilter(c)
	return (c:IsFaceup() and c:IsDefenseBelow(0)) or c:IsFacedown()
end
function c82568007.mrop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82568007.atkfilter,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(-3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetProperty(EFFECT_CANNOT_DISABLE)
		e2:SetValue(-3000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	Duel.BreakEffect()
	local dg=Duel.GetMatchingGroup(c82568007.desfilter,tp,0,LOCATION_MZONE,nil)
	if dg:GetCount()>0 then
	Duel.SendtoGrave(dg,REASON_EFFECT)
end
end
function c82568007.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(82568007)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function c82568007.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c82568007.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then return end
	if Duel.SpecialSummon(c,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)~=0 then
	local ba=c:GetBaseAttack()
	local bd=c:GetBaseDefense()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(ba+1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetProperty(EFFECT_CANNOT_DISABLE)
		e2:SetValue(bd+1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
end
end
