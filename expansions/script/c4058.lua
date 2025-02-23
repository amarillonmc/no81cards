--ナーガの存在
function c4058.initial_effect(c)
	c:SetUniqueOnField(1,0,4058)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c4058.sprcon)
	e1:SetOperation(c4058.sprop)
	c:RegisterEffect(e1)
	--to s/t zone
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCondition(c4058.damcon2)
	e9:SetOperation(c4058.disop)
	c:RegisterEffect(e9)
	--to monster zone
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c4058.damcon)
	e8:SetOperation(c4058.disop2)
	c:RegisterEffect(e8)
	--immune
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_ONFIELD)
	e10:SetValue(c4058.efilter)
	c:RegisterEffect(e10)
	--battle target
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(aux.imval1)
	c:RegisterEffect(e11)
	--triple summon
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(1,0)
	e12:SetValue(3)
	e12:SetTarget(aux.TargetBoolFunction(Card.IsRace,0x8000))
	c:RegisterEffect(e12)
	--oath effects
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e13:SetCode(EFFECT_CANNOT_SUMMON)
	e13:SetTarget(c4058.splimit)
	e13:SetTargetRange(1,0)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e14)
	--replace
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_SEND_REPLACE)
	e15:SetRange(LOCATION_ONFIELD)
	e15:SetTarget(c4058.destg)
	e15:SetValue(c4058.repval)
	c:RegisterEffect(e15)
	--
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(4058)
	e17:SetRange(LOCATION_ONFIELD)
	e17:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e17:SetTargetRange(1,0)
	c:RegisterEffect(e17)
	--extra summon
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e18:SetCode(EVENT_SUMMON_SUCCESS)
	e18:SetRange(LOCATION_ONFIELD)
	e18:SetOperation(c4058.drop)
	c:RegisterEffect(e18)
	--counter
	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e19:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e19:SetRange(LOCATION_MZONE)
	e19:SetCode(EVENT_PHASE+PHASE_END)
	e19:SetCountLimit(1)
	e19:SetOperation(c4058.counter)
	c:RegisterEffect(e19)
	--advance summon
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(4058,1))
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_SUMMON_PROC)
	e20:SetRange(LOCATION_MZONE)
	e20:SetTargetRange(LOCATION_HAND,0)
	e20:SetCondition(c4058.otcon)
	e20:SetTarget(c4058.ottg)
	e20:SetOperation(c4058.otop)
	e20:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e20)
	local e21=e20:Clone()
	e21:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e21)
	--act qp/trap in hand
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e22:SetRange(LOCATION_ONFIELD)
	e22:SetTargetRange(LOCATION_HAND,0)
	e22:SetTarget(aux.TargetBoolFunction(c4058.dafilter))
	c:RegisterEffect(e22)
	--
	local e25=Effect.CreateEffect(c)
	e25:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e25:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e25:SetCode(EVENT_CHAINING)
	e25:SetRange(LOCATION_ONFIELD)
	e25:SetOperation(c4058.actop)
	c:RegisterEffect(e25)
	--public
	local e26=Effect.CreateEffect(c)
	e26:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e26:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e26:SetCode(EVENT_TO_GRAVE)
	e26:SetRange(LOCATION_ONFIELD)
	e26:SetCondition(c4058.con)
	e26:SetOperation(c4058.op)
	c:RegisterEffect(e26)
	local e27=e26:Clone()
	e27:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e27)
	local e28=e26:Clone()
	e28:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e28)
	local e29=e26:Clone()
	e29:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e29)
	local e30=e26:Clone()
	e30:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e30)
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e31:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e31:SetCode(EVENT_CHAIN_SOLVED)
	e31:SetRange(LOCATION_ONFIELD)
	e31:SetOperation(c4058.pubop)
	c:RegisterEffect(e31)
	local e32=e31:Clone()
	e32:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e32)
	local e33=Effect.CreateEffect(c)
	e33:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e33:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e33:SetCode(EVENT_SPSUMMON_SUCCESS)
	e33:SetOperation(c4058.sumsuc)
	c:RegisterEffect(e33)
	--plus effect
	if not c4058.global_check then
		c4058.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c4058.adop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON)
		ge2:SetOperation(c4058.regop)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge3,0)
	end
end

--special summon rule
function c4058.sprfilter(c)
	return c:IsSetCard(0x50) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c4058.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c4058.sprfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	return ft>0 and g:GetClassCount(Card.GetCode)>3
end
function c4058.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4058.sprfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>3 end
	local tg=Group.CreateGroup()
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		tg:Merge(sg)
	end
	Duel.SendtoGrave(tg,REASON_COST)
end

--to s/t zone
function c4058.venomfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x50)
end
function c4058.damcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c4058.venomfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c4058.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(4058,RESET_EVENT+0x1fc0000,0,1)
end

--to monster zone
function c4058.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4058.venomfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) 
end
function c4058.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
end

--immune
function c4058.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--summon limit
function c4058.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_REPTILE)
end

--send leplace
function c4058.vmfilter(c,tp)
	return c:IsFaceup() and c:IsCode(8062132) and c:IsControler(tp)
end
function c4058.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c4058.vmfilter,1,nil,tp)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c4058.repval(e,c)
	return c:IsFaceup() and c:IsCode(8062132) and c~=e:GetHandler()
end

--extra summon
function c4058.sufilter(c,e,tp)
	return c:IsControler(tp) and c:IsRace(RACE_REPTILE) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c4058.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function c4058.exfilter(c,e,tp,lv)
	return (c:GetRank()==lv or c:GetLevel()==lv) and c:IsRace(RACE_REPTILE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c4058.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c4058.sufilter,1,nil,e,tp) then
		if not c:IsLocation(LOCATION_MZONE) and not eg:IsExists(Card.IsSetCard,1,nil,0x50) then return end
		local g=eg:Filter(c4058.sufilter,nil,e,tp)
		local tc=g:GetFirst()
		local lv=tc:GetLevel()
		if Duel.IsExistingMatchingCard(c4058.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
			and Duel.SelectYesNo(tp,aux.Stringid(4058,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c4058.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

--counter
function c4058.counter(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4058.vmfilter,tp,LOCATION_MZONE,0,nil,tp)
	local sg=Group.CreateGroup()
	if g:GetCount()==0 then return end
	if g:GetCount()==1 then
		sg:AddCard(g:GetFirst())
	else
		sg:AddCard(g:Select(tp,1,1,nil):GetFirst())
	end
	local tc=sg:GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	tc:AddCounter(0x11,1)
	local WIN_REASON_VENNOMINAGA = 0x12
	if tc:GetCounter(0x11)==3 then
		Duel.Win(tp,WIN_REASON_VENNOMINAGA)
	end
end

--advance
function c4058.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c4058.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return ((mi<=2 and ma>=2 and Duel.IsExistingMatchingCard(c4058.sprfilter,e:GetHandlerPlayer(),LOCATION_DECK,0,2,nil))
		or (mi<=1 and ma>=1) and Duel.IsExistingMatchingCard(c4058.sprfilter,e:GetHandlerPlayer(),LOCATION_DECK,0,1,nil))
		and c:IsRace(RACE_REPTILE)
end
function c4058.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mi,ma=c:GetTributeRequirement()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4058.sprfilter,tp,LOCATION_DECK,0,mi,ma,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

--act in hand
function c4058.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if re:GetActivateLocation()~=LOCATION_HAND then return end
	if not rc:IsCode(16067089,93217231,80678380,1683982) then return end
	Duel.RegisterFlagEffect(rc:GetControler(),rc:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
end

--public
function c4058.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_DECK) or c:GetSummonLocation()==LOCATION_DECK
			or (c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK))
			or c:IsLocation(LOCATION_DECK)) and not c:IsReason(REASON_DRAW)
end
function c4058.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4058.cfilter,1,nil,tp)
end
function c4058.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	c:RegisterFlagEffect(4058,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c4058.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(4058)~=0 and Duel.IsExistingMatchingCard(c4058.dafilter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c4058.dafilter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
end
function c4058.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c4058.dafilter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c4058.dafilter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
end

--plus effect
function c4058.dafilter(c)
	return c:IsType(TYPE_TRAP) and c:IsCode(16067089,93217231,80678380,1683982) and Duel.GetFlagEffect(c:GetControler(),c:GetOriginalCode())==0
end
function c4058.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4058.dafilter,c:GetControler(),LOCATION_DECK,LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(4058)==0 then
			local code=tc:GetOriginalCode()
			local ae=tc:GetActivateEffect()
			--deck activate
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(ae:GetCode())
			e1:SetCategory(ae:GetCategory())
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+ae:GetProperty())
			e1:SetRange(LOCATION_DECK)
			e1:SetCountLimit(1,code+EFFECT_COUNT_CODE_OATH)
			e1:SetCondition(c4058.sfcon)
			e1:SetTarget(c4058.sftg)
			e1:SetOperation(c4058.sfop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			--activate cost
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetRange(LOCATION_DECK)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(LOCATION_DECK,0)
			e2:SetCost(c4058.costchk)
			e2:SetTarget(c4058.actarget)
			e2:SetOperation(c4058.costop)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetLabel(4058)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(4058,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=g:GetNext()
	end
end

--deck activate
function c4058.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,4058) and Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())==0
end
function c4058.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ae=e:GetHandler():GetActivateEffect()
	local fcon=ae:GetCondition()
	local fcos=ae:GetCost()
	local ftg=ae:GetTarget()
	if chk==0 then
		return (not fcon or fcon(e,tp,eg,ep,ev,re,r,rp))
			and (not fcos or fcos(e,tp,eg,ep,ev,re,r,rp,0))
			and (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,0))
			and e:GetHandler():IsCode(16067089,93217231,80678380,1683982)
	end
	if fcos then fcos(e,tp,eg,ep,ev,re,r,rp,1) end
	if ftg then ftg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
end
function c4058.sfop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	if fop then fop(e,tp,eg,ep,ev,re,r,rp) end
end

--activate field
function c4058.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler():IsLocation(LOCATION_HAND+LOCATION_DECK) and te:GetHandler()==e:GetHandler()
end
function c4058.costchk(e,te_or_c,tp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c4058.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c4058.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c4058.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end

--summon check
function c4058.sumcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),4058)==0
end
function c4058.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if not tc:IsRace(RACE_REPTILE) or (tc:IsFacedown() and not Duel.IsPlayerAffectedByEffect(tc:GetSummonPlayer(),4058)) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),4058,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

local re=Card.RegisterEffect
Card.RegisterEffect=function(c,e)
	if c:IsType(TYPE_TRAP) and c:IsCode(16067089,93217231,80678380,1683982) and c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD) and not e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()~=4058 then
		local tg=e:GetTarget()
		if not tg then tg=aux.TRUE end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) and not c:IsStatus(STATUS_CHAINING) end tg(e,tp,eg,ep,ev,re,r,rp,1) end)
	end
	re(c,e)
end
