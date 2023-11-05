local m=15000202
local cm=_G["c"..m]
cm.name="『虚无』的██-IX"
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.effcon)
	c:RegisterEffect(e1)
	--placec
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(cm.scon)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.scon2)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.cgcon)
	e6:SetOperation(cm.cgop)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHAINING)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_ATTACK_ANNOUNCE)
		Duel.RegisterEffect(ge4,0)
		--SpecialSummon
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge5:SetOperation(cm.xyzregop)
		Duel.RegisterEffect(ge5,0)
	end
end
function cm.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetOriginalRank)==1 and g:GetClassCount(Card.GetRank)~=1
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SPSUMMON_SUCCESS then
		local sg=eg:Filter(Card.IsSummonPlayer,nil,0)
		local og=eg:Filter(Card.IsSummonPlayer,nil,1)
		if #sg~=0 and Duel.GetFlagEffect(0,15000202)==0 then
			Duel.RegisterFlagEffect(0,15000202,RESET_PHASE+PHASE_END,0,1)
		end
		if #og~=0 and Duel.GetFlagEffect(1,15000202)==0 then
			Duel.RegisterFlagEffect(1,15000202,RESET_PHASE+PHASE_END,0,1)
		end
	end
	if e:GetCode()==EVENT_CHAINING then
		local p=ep
		if p==0 and Duel.GetFlagEffect(0,15000202)==0 then
			Duel.RegisterFlagEffect(0,15000202,RESET_PHASE+PHASE_END,0,1)
		end
		if p==1 and Duel.GetFlagEffect(1,15000202)==0 then
			Duel.RegisterFlagEffect(1,15000202,RESET_PHASE+PHASE_END,0,1)
		end
	end
	if e:GetCode()==EVENT_ATTACK_ANNOUNCE then
		local p=Duel.GetAttacker():GetControler()
		if p==0 and Duel.GetFlagEffect(0,15000202)==0 then
			Duel.RegisterFlagEffect(0,15000202,RESET_PHASE+PHASE_END,0,1)
		end
		if p==1 and Duel.GetFlagEffect(1,15000202)==0 then
			Duel.RegisterFlagEffect(1,15000202,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.xyzregop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(15000202) and tc:IsSummonType(SUMMON_TYPE_XYZ) then
			if tc:IsSummonPlayer(0) and Duel.GetFlagEffect(0,15000203)==0 then
				Duel.RegisterFlagEffect(0,15000203,0,0,1)
			end
			if tc:IsSummonPlayer(1) and Duel.GetFlagEffect(1,15000203)==0 then
				Duel.RegisterFlagEffect(1,15000203,0,0,1)
			end
		end
	end
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and Duel.GetFlagEffect(tp,15000202)==0 and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,15000203)~=0
end
function cm.scon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsPreviousLocation(LOCATION_OVERLAY) and Duel.GetFlagEffect(tp,15000202)==0 and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,15000203)~=0
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
end
function cm.cgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,15000202)==0 and Duel.GetFlagEffect(tp,15000203)~=0
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.SetLP(tp,Duel.GetLP(tp)-500)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
end