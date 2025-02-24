--胜业轮转
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,55500000)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(s.cost)
	c:RegisterEffect(e0)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.acop)
	c:RegisterEffect(e3)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_MSET)
	c:RegisterEffect(e7)
	--to hand
	local e8=Effect.CreateEffect(c) 
	e8:SetDescription(aux.Stringid(id,1))
	e8:SetCategory(CATEGORY_TOHAND) 
	e8:SetType(EFFECT_TYPE_QUICK_O) 
	e8:SetCode(EVENT_FREE_CHAIN) 
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e8:SetRange(LOCATION_SZONE) 
	e8:SetTarget(s.tgtg) 
	e8:SetOperation(s.tgop) 
	c:RegisterEffect(e8)
	
	--cannot target
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetCondition(s.incon)
	e9:SetValue(aux.tgoval)
	c:RegisterEffect(e9)
	--indes
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCondition(s.incon)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCode(EFFECT_CANNOT_REMOVE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetTargetRange(1,1)
	e11:SetTarget(s.efilter)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetRange(LOCATION_SZONE)
	e12:SetValue(s.efilter1)
	e12:SetOwnerPlayer(tp)
	c:RegisterEffect(e12)
	--inactivatable
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_CANNOT_INACTIVATE)
	e13:SetRange(LOCATION_SZONE)
	e13:SetValue(s.effectfilter)
	c:RegisterEffect(e13)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_CANNOT_DISEFFECT)
	e14:SetRange(LOCATION_SZONE)
	e14:SetValue(s.effectfilter)
	c:RegisterEffect(e14)
	--cannot disable
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_CANNOT_DISABLE)
	e13:SetRange(LOCATION_SZONE)
	e15:SetTargetRange(1,0)
	e15:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e15:SetTarget(s.indtg)
	c:RegisterEffect(e15)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
	--SearchCard
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(id,0))
	e16:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e16:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e16:SetRange(LOCATION_SZONE)
	e16:SetCountLimit(1)
	e16:SetTarget(s.e16tg)
	e16:SetOperation(s.e16op)
	c:RegisterEffect(e16)
end
function s.incon(e)
	return e:GetHandler():GetCounter(0x189c)>=1
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local c=e:GetHandler()
	if not re:GetHandler():IsCode(55500000) and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		e:GetHandler():AddCounter(0x189c,1)
	end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x189c,1)
end

function s.mfilter(c) 
	return aux.IsCodeListed(c,55500000) and c:IsAbleToHand()
end 
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_MONSTER) and aux.IsCodeListed(rc,55500000))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.active_limit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.active_limit(e,re,tp,cid)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and aux.IsCodeListed(rc,55500000)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end 
function s.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil) then 
		local g=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_MZONE,0,1,1,nil) 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end 
end 

function s.val1(e,re,rp)
	return e:GetHandler():GetCounter(0x189c)>=1 and rp==1-e:GetHandlerPlayer()
end
function s.val2(e,re,rp)
	return e:GetHandler():GetCounter(0x189c)>=1
end
function s.efilter(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c==e:GetHandler() and rp==1-tp and e:GetHandler():GetCounter(0x189c)>=1
end

function s.efilter1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and e:GetHandler():GetCounter(0x189c)>=10
end

function s.effectfilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return tp==e:GetHandlerPlayer() and aux.IsCodeListed(tc,55500000) and e:GetHandler():GetCounter(0x189c)>=30
end
function s.indtg(e,c)
	return aux.IsCodeListed(c,55500000) and e:GetHandler():GetCounter(0x189c)>=30
end
function s.e16filter(c)
	return aux.IsCodeListed(c,55500000) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.e16tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e16filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,0,0)
end
function s.e16op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.e16filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end