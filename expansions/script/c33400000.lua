--星眼
XY=XY or {}

-------------------------------------------
nef=Effect.CreateEffect
tpara={e,tp,eg,ep,ev,re,r,rp}
para=table.unpack(tpara)
------
function XY.REZS(c)
if c:IsSetCard(0x5349) and not (c:GetCode()==33403501) then 
		--set
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ge2:SetCode(EVENT_PHASE+PHASE_END)
	ge2:SetRange(LOCATION_GRAVE)
	ge2:SetCondition(XY.recon)
	ge2:SetCost(XY.recost)
	ge2:SetTarget(XY.resettg)
	ge2:SetOperation(XY.resetop)
	c:RegisterEffect(ge2)
else 
 --draw
	local ge3=Effect.CreateEffect(c)
	ge3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ge3:SetRange(LOCATION_GRAVE)
	ge3:SetCode(EVENT_PHASE+PHASE_END)
	ge3:SetCondition(XY.recon)
	ge3:SetCost(XY.recost)
	ge3:SetTarget(XY.drtg)
	ge3:SetOperation(XY.drop)
	c:RegisterEffect(ge3)
end 
if c:IsSetCard(0x5349) and  c:IsType(TYPE_TRAP) then 
  --act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(XY.handcon)
	c:RegisterEffect(e3)
end
	  if not XY.zs then
        XY.zs=true
        local ge1=Effect.GlobalEffect(c)
        ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)     
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetCondition(XY.zscon1)
        ge1:SetOperation(XY.zsop1)
        Duel.RegisterEffect(ge1,0)
    end
end
function XY.zsfilter1(c,rp)
    return   Duel.GetFlagEffect(rp,33443500)==0  
end
function XY.zsckfilter1(c,rp,re)
    return c:GetSummonPlayer()==rp and   not c:IsCode(33403500) and (re and not re:GetHandler():IsSetCard(0x5349))
end
function XY.zscon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(XY.zsfilter1,1,nil,rp)       
end
function XY.zsop1(e,tp,eg,ep,ev,re,r,rp)
    if  eg:IsExists(XY.zsckfilter1,1,nil,rp,re)  then   
    Duel.RegisterFlagEffect(rp,33443500,RESET_PHASE+PHASE_END,0,1)
    end 
end

function XY.handcon(e)
	return Duel.IsExistingMatchingCard(XY.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function XY.hdfilter(c)
	return c:IsFaceup() and   c:IsCode(33403500) 
end

function XY.recost(e,tp,eg,ep,ev,re,r,rp,chk)  
if chk==0 then return   aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)  end
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

function XY.recon(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
local ss=Duel.GetFlagEffect(tp,33403501)
	local sx=0
	while(sx<(ss/2+2))
	do
	sx=sx+1
	ss=ss+1
	end
	return   Duel.GetFlagEffect(tp,33413501)<sx and Duel.GetFlagEffect(tp,c:GetCode()+20000)==0  and  Duel.GetFlagEffect(tp,33443500)==0  
end
function XY.REstfilter(c,m)
	return c:IsSetCard(0x5349) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(m)
end
function XY.resettg(e,tp,eg,ep,ev,re,r,rp,chk)
 local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(XY.REstfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
end
function XY.resetop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,XY.REstfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode())
	if #g>0 then
		Duel.SSet(tp,g)
	end
end

function XY.drfilter(c,e)
	return c:IsSetCard(0x5349) and c:IsAbleToDeck() 
end
function XY.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local c=e:GetHandler()
	if chkc then return false end
	local g=Duel.GetMatchingGroup(XY.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	local n=g:GetCount()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and n>=5  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)
end
function XY.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,XY.drfilter,tp,LOCATION_REMOVED,0,5,5,nil,e)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp) 
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end

