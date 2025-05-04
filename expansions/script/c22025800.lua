--冠位异星 奥尔特·希巴尔巴
function c22025800.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,22025780,22025790,true,true)
	aux.AddContactFusionProcedure(c,c22025800.cfilter,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c22025800.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22025800.indcon)
	e3:SetValue(c22025800.efilter)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetDescription(aux.Stringid(22025800,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c22025800.descon)
	e4:SetTarget(c22025800.destg)
	e4:SetOperation(c22025800.desop)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetValue(c22025800.aclimit)
	c:RegisterEffect(e5)
	--win
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_ADJUST)
	e6:SetOperation(c22025800.winop)
	c:RegisterEffect(e6)
	if not c22025800.global_flag then
		c22025800.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22025800.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22025800.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22025780) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22025800,0,0,0)
		elseif tc:IsCode(22025790) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22025801,0,0,0)
		end
	end
end
function c22025800.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c22025800.cfilter(c,fc)
	local tp=fc:GetControler()
	return c:IsFusionCode(22025780,22025790) and c:IsAbleToRemoveAsCost() and Duel.GetFlagEffect(tp,22025800)>0 and Duel.GetFlagEffect(tp,22025801)>0
end

function c22025800.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1
end
function c22025800.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22025800.indcon(e)
	return not Duel.IsExistingMatchingCard(c22025800.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22025800.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c22025800.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_REMOVED 
end

function c22025800.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22025800.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c22025800.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
end

function c22025800.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DISASTER_LEO=0x11
	if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END
		and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD)==1 then
		Duel.Win(tp,WIN_REASON_DISASTER_LEO)
	end
end