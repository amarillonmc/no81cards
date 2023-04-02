--暗裔剑魔 亚托克斯
local m=14010279
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(cm.spscost)
	e1:SetTarget(cm.spstg)
	e1:SetOperation(cm.spsop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.motg)
	e3:SetOperation(cm.moop)
	c:RegisterEffect(e3)
end
function cm.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.spsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.desfilter1(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
end
function cm.desfilter2(c,s)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1
end
function cm.desfilter3(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,m)==0 then
		cg=c:GetColumnGroup():Filter(cm.desfilter1,nil,1-tp)
	elseif Duel.GetFlagEffect(tp,m)==1 then
		local seq=4-c:GetSequence()
		cg=Duel.GetMatchingGroup(cm.desfilter2,tp,0,LOCATION_MZONE,nil,seq)
	elseif Duel.GetFlagEffect(tp,m)==2 then
		cg=c:GetColumnGroup():Filter(cm.desfilter3,nil,1-tp)
	end
	if chk==0 then return cg:GetCount()>0 and c:GetFlagEffect(m)==0 and Duel.GetFlagEffect(tp,m)<3 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,cg:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,m)==0 then
		cg=c:GetColumnGroup():Filter(cm.desfilter1,nil,1-tp)
	elseif Duel.GetFlagEffect(tp,m)==1 then
		local seq=4-c:GetSequence()
		cg=Duel.GetMatchingGroup(cm.desfilter2,tp,0,LOCATION_MZONE,nil,seq)
	elseif Duel.GetFlagEffect(tp,m)==2 then
		cg=c:GetColumnGroup():Filter(cm.desfilter3,nil,1-tp)
	end
	if c:IsRelateToEffect(e) and cg:GetCount()>0 then
		Duel.Destroy(cg,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.motg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.moop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
end