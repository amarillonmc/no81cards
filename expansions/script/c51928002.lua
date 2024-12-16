--狂风精灵 旋风
function c51928002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51928002+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c51928002.spcon)
	e1:SetOperation(c51928002.spop)
	c:RegisterEffect(e1)
	 --disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51928002,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,51928002)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c51928002.discon)
	e2:SetCost(c51928002.discost)
	e2:SetTarget(c51928002.distg)
	e2:SetOperation(c51928002.disop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51928002,ACTIVITY_SPSUMMON,c51928002.counterfilter)
end
function c51928002.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER))
end
--------------------------------------


function c51928002.filter(c)
	return c:IsType(TYPE_TUNER) and c:IsFaceup()
end
function c51928002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetCustomActivityCount(51928002,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51928002.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c51928002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51928002.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51928002.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end
-------------------------------------------------
function c51928002.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c51928002.cfilter(c)
	return c:IsType(TYPE_TUNER)
end
function c51928002.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c51928002.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c51928002.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
function c51928002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c51928002.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsDestructable()
		and (e:GetLabelObject():IsType(TYPE_SYNCHRO))
		and Duel.SelectYesNo(tp,aux.Stringid(51928002,2)) then
		Duel.BreakEffect()
		Duel.Destroy(rc,REASON_EFFECT)
	end
end







