--卓越创造物Ω
byd=byd or {}
byd.loaded_metatable_list={}

local cm,m,o=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	
	byd.GArtifact(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLP(tp)<8000 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<8000 then Duel.SetLP(tp,8000) end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local dg=Group.CreateGroup()
		for tc in aux.Next(g) do
			local preatk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if preatk~=0 and (tc:IsAttack(0) or tc:IsDefense(0)) then dg:AddCard(tc) end
		end
		if #dg~=0 then Duel.Destroy(dg,REASON_EFFECT) end
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function byd.GArtifact(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(byd.spcon)
	e2:SetTarget(byd.sptg)
	e2:SetOperation(byd.spop)
	c:RegisterEffect(e2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(byd.rcon)
	e1:SetOperation(byd.rop)
	c:RegisterEffect(e1)
	
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_HAND+LOCATION_DECK)
	e3:SetOperation(byd.checkop)
	c:RegisterEffect(e3)
end
function byd.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(byd.spfil,tp,LOCATION_MZONE,0,1,c) and Duel.GetFlagEffect(tp,60001511)~=0
end
function byd.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(byd.spfil,tp,LOCATION_MZONE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function byd.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function byd.spfil(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsReleasable()
end
function byd.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsAbleToRemove()
end
function byd.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	Duel.Readjust()
end
function byd.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()~=1 then return end
	if not byd.SpaceCheck then
		byd.SpaceCheck=1
		if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK,0,nil)>=60 then
			Duel.RegisterFlagEffect(tp,60001511,0,0,1)
		end
	end
	if Duel.GetFlagEffect(tp,60001511)~=0 and Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_RULE)~=0 and e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end


function byd.Countdown(c,num,tf)
	c:EnableCounterPermit(0x625,LOCATION_ONFIELD)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(num,tf)
	e1:SetTarget(byd.Countdowntg)
	e1:SetOperation(byd.Countdownop)
	c:RegisterEffect(e1)
end
function byd.Countdowntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x625,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
end
function byd.Countdownop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num,tf=e:GetLabel()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x625,num)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60001511,1))
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetOperation(byd.Countdowncost)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_SELF_DESTROY)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetCondition(byd.Countdowncon)
		c:RegisterEffect(e1)
		if tf==1 then
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(60001511,2))
			e3:SetCategory(CATEGORY_COUNTER)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetRange(LOCATION_SZONE)
			e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
			e3:SetCountLimit(1)
			e3:SetTarget(byd.CountdownAtg)
			e3:SetOperation(byd.CountdownAop)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e3)
		end
	end
end
function byd.Countdowncost(e,tp,eg,ep,ev,re,r,rp)
	if Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end
function byd.Countdowncon(e)
	return Card.GetCounter(e:GetHandler(),0x625)==0
end
function byd.CountdownAtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
end
function byd.CountdownAop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc and c:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)~=0 then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end

function byd.CountdownSP(c,num)
	c:EnableCounterPermit(0x624)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(c:GetOriginalCode(),num)
	e1:SetCondition(byd.CountdownSPcon)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DISCARD)
	e2:SetLabel(c:GetOriginalCode())
	e2:SetTarget(byd.CountdownSPtg)
	e2:SetOperation(byd.CountdownSPop)
	c:RegisterEffect(e2)
end
function byd.CountdownSPcon(e)
	local code,num=e:GetLabel()
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),code)>=num and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function byd.CountdownSPtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
end
function byd.CountdownSPop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
	end
end

function byd.Spellboost(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(byd.counterop)
	c:RegisterEffect(e2)
end
function byd.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		if not c:IsPublic() then
			local e11=Effect.CreateEffect(c)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_PUBLIC)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e11)
		end
		c:RegisterFlagEffect(60001538,RESET_EVENT+RESET_LEAVE+RESET_TODECK+RESET_TOGRAVE+RESET_REMOVE,0,1)
	end
end











