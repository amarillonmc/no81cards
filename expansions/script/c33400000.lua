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
	return Duel.GetFlagEffect(tp,33413502)<Duel.GetTurnCount() and Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and Duel.GetFlagEffect(tp,33443500)==0   
end
function XY.REstfilter(c,m)
	return c:IsSetCard(0x5349) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(m)
end
function XY.resettg(e,tp,eg,ep,ev,re,r,rp,chk)
 local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(XY.REstfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413502,RESET_PHASE+PHASE_END,0,1)
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
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)  and g:GetClassCount(Card.GetCode)>=5  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413502,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)
end
function XY.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(XY.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	if g:GetClassCount(Card.GetCode)>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp) 
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
	end
end
------mayuri
function XY.mayuri(c)
local cd=c:GetCode()
	if not c:IsLevel(12) then
--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(XY.mayuribfcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e0:SetOperation(XY.mayuriregop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(XY.mayuriregcon)
	e1:SetOperation(XY.mayuriregop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(XY.mayuriregcon)
	e2:SetOperation(XY.mayuriregop2)
	c:RegisterEffect(e2)
	end
	if c:IsLevel(4) then 
	  --spsummon
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e5:SetCode(EVENT_SUMMON_SUCCESS)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetRange(LOCATION_HAND)
		e5:SetCountLimit(1,cd)
		e5:SetCondition(XY.mayurispcon)   
		e5:SetTarget(XY.mayurisptg)
		e5:SetOperation(XY.mayurispop)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e6)
	end
	if c:IsLevel(8) then 
	--sp
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,cd)
	e5:SetCondition(XY.mayurispcon2)
	e5:SetTarget(XY.mayurisptg2)
	e5:SetOperation(XY.mayurispop2)
	c:RegisterEffect(e5)
	end
end
--inside
function XY.mayuribfcon(e)
	return e:GetHandler():GetFlagEffect(e:GetHandler():GetCode())==0
end
function XY.mayuriregop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33401601,0))
end
function XY.mayuriregcon(e,tp,eg,ep,ev,re,r,rp)
	return  re:GetHandler()==e:GetHandler()
end
function XY.mayuriregop1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33401601,0))
end
function XY.mayuriregop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local fs=c:GetFlagEffect(c:GetCode())
	c:ResetFlagEffect(c:GetCode())
	for i=1,fs-1 do
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33401601,0))
	end
end
--sp
function XY.mayuricfilter(c,at)
	return c:IsFaceup() and( c:IsSetCard(0x6344) or c:GetAttribute()&at~=0)
end
function XY.mayurispcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(XY.mayuricfilter,1,nil,c:GetAttribute()) 
end
function XY.mayurisptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function XY.mayurispop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or   not c:IsRelateToEffect(e)  then return end
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(XY.mayurispfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function XY.mayurispfilter(e,c)
	return not c:IsSetCard(0x341) and c:IsLocation(LOCATION_EXTRA)
end
--leave sp
function XY.mayurispcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and  c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function XY.mayurispfilter2(c,e,tp,at)
	return  c:IsSetCard(0x341) and c:IsLevel(4) and c:IsAttribute(at) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function XY.mayurisptg2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(XY.mayurispfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function XY.mayurispop2(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,XY.mayurispfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetAttribute())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end