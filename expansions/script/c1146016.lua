--辉光之针的魔法少女
function c1146016.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c1146016.FusFilter1,c1146016.FusFilter2,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c1146016.splimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1146016,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1146016.con2)
	e2:SetOperation(c1146016.op2)
	c:RegisterEffect(e2)
--
	if not c1146016.global_check then
		c1146016.global_check=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_LEVEL_UP)
		e3:SetLabelObject(c)
		e3:SetOperation(c1146016.op3)
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e4:SetTarget(function (e,c) return c:IsFaceup() end)
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,0)
	end
--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CUSTOM+1146016)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,1146016)
	e5:SetTarget(c1146016.tg5)
	e5:SetOperation(c1146016.op5)
	c:RegisterEffect(e5)
--
end
--
function c1146016.FusFilter1(c)
	return c:IsRace(RACE_FIEND)
end
function c1146016.FusFilter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end
--
function c1146016.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
--
function c1146016.con2(e,tp,eg,ep,ev,re,r,rp)
	local b1=eg and eg:IsExists(aux.TRUE,1,e:GetHandler())
	local b2=(Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
	return b1 and b2
end
--
function c1146016.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if mg:GetCount()<1 then return end
	local tc=mg:GetFirst()
	while tc do
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2_1:SetValue(-1200)
		tc:RegisterEffect(e2_1)
		tc=mg:GetNext()
	end
	Duel.BreakEffect()
	local dg=mg:Filter(Card.IsAttack,nil,0)
	if dg:GetCount()<1 then return end
	Duel.Destroy(dg,REASON_EFFECT)
end
--
function c1146016.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.RaiseEvent(c,EVENT_CUSTOM+1146016,re,r,rp,ep,ev)
end
--
function c1146016.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1146016.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
