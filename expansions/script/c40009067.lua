--睿智之蓝 LV11·灵摆扩张
function c40009067.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.penlimit)
	c:RegisterEffect(e1)   
	--spsummon from hand
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetCondition(c40009067.hspcon)
	e2:SetOperation(c40009067.hspop)
	c:RegisterEffect(e2) 
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009067,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c40009067.target)
	e3:SetOperation(c40009067.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009067,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCost(c40009067.thcost)
	e4:SetCondition(c40009067.spcon)
	e4:SetTarget(c40009067.sptg)
	e4:SetOperation(c40009067.spop)
	c:RegisterEffect(e4)
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c40009067.psplimit)
	c:RegisterEffect(e5)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(40009067,4))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCondition(c40009067.ctcon)
	e7:SetTarget(c40009067.cttg)
	e7:SetOperation(c40009067.ctop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
c40009067.lvupcount=1
c40009067.lvup={40006763}
c40009067.lvdncount=2
c40009067.lvdn={40006762,40006763}
function c40009067.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xf24) and c:IsControler(tp)
end
function c40009067.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009067.ctfilter,1,nil,tp)
end
function c40009067.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c40009067.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c40009067.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local lvl=1
		local sel=Duel.SelectOption(tp,aux.Stringid(40009067,5),aux.Stringid(40009067,6))
		if sel==1 then
			lvl=-1
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c40009067.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c40009067.hspfilter(c,tp)
	return c:IsCode(40006764) and c:IsControler(tp)
end
function c40009067.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=0
	if Duel.CheckReleaseGroup(tp,c40009067.hspfilter,1,nil,tp) then ct=ct-1 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
		and Duel.CheckReleaseGroupEx(tp,Card.IsCode,1,e:GetHandler(),40006764)
end
function c40009067.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		g=Duel.SelectReleaseGroupEx(tp,Card.IsCode
,1,1,e:GetHandler(),40006764)
	else
		g=Duel.SelectReleaseGroup(tp,c40009067.hspfilter,1,1,nil,tp)
	end
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40009067,0))
end
function c40009067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil) end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c40009067.spfilter1(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009067.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=Duel.GetAttacker()
	if c:IsRelateToBattle() then g:AddCard(c) end
	c=Duel.GetAttackTarget()
	if c~=nil and c:IsRelateToBattle() then g:AddCard(c) end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40009067.spfilter1),tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(40009067,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40009067.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c40009067.thfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsCode(40006763) and c:IsAbleToRemoveAsCost()
end
function c40009067.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009067.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40009067.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40009067.spfilter(c,e,tp)
	return c:IsCode(40006764) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c40009067.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009067.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c40009067.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009067.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
end