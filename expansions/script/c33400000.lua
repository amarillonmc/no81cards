--星眼
XY=XY or {}

-------------------------------------------
nef=Effect.CreateEffect
tpara={e,tp,eg,ep,ev,re,r,rp}
para=table.unpack(tpara)
------
function XY.REZS(c)
if not (c:GetCode()==33403501) then 
		--set
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_QUICK_O)
	ge2:SetCode(EVENT_FREE_CHAIN)
	ge2:SetRange(LOCATION_GRAVE)
	ge2:SetCost(XY.recost)
	ge2:SetTarget(XY.resettg)
	ge2:SetOperation(XY.resetop)
	c:RegisterEffect(ge2)
end 
	if not XY.zs then
		XY.zs=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(XY.zscon1)
		ge1:SetOperation(XY.zsop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function XY.zsfilter1(c,tp,re)
	return c:GetSummonPlayer()==tp and  not c:IsCode(33403500) and (re and not re:GetHandler(0x5349))
end
function XY.zscon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(XY.zsfilter1,1,nil,tp,re)		
end
function XY.zsop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33443500)
end

function XY.recost(e,tp,eg,ep,ev,re,r,rp,chk)  
if chk==0 then return  Duel.GetFlagEffect(tp,33443500)==0
		and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)  end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(XY.REsplimit)
	Duel.RegisterEffect(e1,tp) 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function XY.REsplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349) and  not c:IsCode(33403500)
end

function XY.REstfilter(c,m)
	return c:IsSetCard(0x5349) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(m)
end
function XY.resettg(e,tp,eg,ep,ev,re,r,rp,chk)
 local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(XY.REstfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(XY.regcon)
	e2:SetOperation(XY.regop3)
	e2:SetReset(RESET_EVENT+RESET_CHAIN+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function XY.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x5349) and rp==tp
end
function XY.regop3(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local m=c:GetCode()
	local n1=Duel.GetFlagEffect(tp,33413501)
	local n3=Duel.GetFlagEffect(tp,m+30000)
	Duel.ResetFlagEffect(tp,33403501)
	Duel.ResetFlagEffect(tp,m+30000)
	if n1>=2 then 
		for i=1,n1-1 do
		Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1)
		end 
	end
	if n3>=2 then 
		for i=1,n3-1 do
		  Duel.RegisterFlagEffect(tp,m+30000,RESET_PHASE+PHASE_END,0,1)
		end 
	end
end
function XY.resetop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,XY.REstfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode())
	if #g>0 then
		Duel.SSet(tp,g)
	end
end