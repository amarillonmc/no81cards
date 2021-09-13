--逆方舟骑士·盾 爱国者
function c82567899.initial_effect(c)
	--fusion material
	aux.EnablePendulumAttribute(c,false)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c82567899.ffilter,3,true)
	--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c82567899.addct)
	e4:SetOperation(c82567899.addc)
	c:RegisterEffect(e4)
	--Reunion defup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x825))
	e5:SetValue(c82567899.rlatkval)
	c:RegisterEffect(e5)
	--Reunion atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x825))
	e6:SetValue(c82567899.rlatkval)
	c:RegisterEffect(e6)
	--battle target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e7:SetValue(c82567899.atlimit)
	c:RegisterEffect(e7)
	--EFFECT target
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e10:SetTargetRange(LOCATION_MZONE,0)
	e10:SetTarget(aux.TargetBoolFunction(c82567899.atlimit))
	e10:SetValue(aux.tgoval)
	e10:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e7)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c82567899.condition)
	e8:SetOperation(c82567899.operation)
	c:RegisterEffect(e8)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
	--pendulum
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCondition(c82567899.pencon)
	e11:SetTarget(c82567899.pentg)
	e11:SetOperation(c82567899.penop)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_ATKCHANGE)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_PZONE)
	e12:SetCountLimit(1)
	e12:SetCost(c82567899.cost)
	e12:SetCondition(c82567899.con)
	e12:SetOperation(c82567899.atdop)
	c:RegisterEffect(e12)
	--Revive
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(82567899,2))
	e13:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetCode(EVENT_PHASE+PHASE_END)
	e13:SetRange(LOCATION_PZONE)
	e13:SetCountLimit(1,82567899+EFFECT_COUNT_CODE_DUEL)
	e13:SetCondition(c82567899.sumcon)
	e13:SetTarget(c82567899.sumtg)
	e13:SetOperation(c82567899.sumop)
	c:RegisterEffect(e13)
end
function c82567899.ffilter(c)
	return c:IsFusionSetCard(0x825) and c:IsLevelAbove(6) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND))
end
function c82567899.rlatkval(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rl=c:GetCounter(0x5824)
	return rl*100
end
function c82567899.rfilter(c,tp)
	return c:IsSetCard(0x825) and (c:IsControler(tp) or c:IsFaceup())
end
function c82567899.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c82567899.rmzfilter(c,tp)
	return c:IsSetCard(0x825) and c:IsControler(tp) and c:GetSequence()<5
end
function c82567899.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-3 and rg:GetCount()>2 and rg:IsExists(c82567899.rfilter,1,nil,tp)
		and (ft>0 or rg:IsExists(c82567899.mzfilter,ct,nil,tp))
		and (ft>-2 or rg:IsExists(c82567899.rmzfilter,1,nil,tp))
end
function c82567899.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x825)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c82567899.rmzfilter,1,1,nil,tp)
	end
	local tc=g:GetFirst()
	if tc:IsControler(tp) and tc:GetSequence()<5 then ft=ft+1 end
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,2,2,tc)
		g:Merge(g2)
	elseif ft>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:FilterSelect(tp,c82567899.mzfilter,1,1,tc,tp)
		g:Merge(g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g3=rg:Select(tp,1,1,g)
		g:Merge(g3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:FilterSelect(tp,c82567899.mzfilter,2,2,tc,tp)
		g:Merge(g2)
	end
	Duel.Release(g,REASON_COST)
end
function c82567899.ctfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_MONSTER)
end
function c82567899.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x5824)
end
function c82567899.addc(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c82567899.ctfilter,tp,LOCATION_GRAVE,0,nil)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x5824,ct)
	end
end
function c82567899.atlimit(e,c)
	return c:IsFaceup() and not (c:GetBaseAttack() <= c:GetBaseDefense()) and c:IsSetCard(0x825)
end
function c82567899.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()==0 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c82567899.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
end
end
function c82567899.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) 
end
function c82567899.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c82567899.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c82567899.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp/2)
	Duel.PayLPCost(tp,lp/2)
	e:GetHandler():RegisterFlagEffect(82567899,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c82567899.desfilter(c)
	return c:IsFaceup() 
end
function c82567899.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567899.desfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c82567899.atdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567899.desfilter,tp,0,LOCATION_MZONE,nil)
	local atk=e:GetLabel()
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c82567899.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(82567899)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function c82567899.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_PZONE)
end
function c82567899.sumop(e,tp,eg,ep,ev,re,r,rp)
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