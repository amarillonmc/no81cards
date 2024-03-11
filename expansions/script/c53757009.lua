local m=53757009
local cm=_G["c"..m]
cm.name="次元秽界 冽"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e0,e1,e3,e5,e6,e6_1=SNNM.DragoronActivate(c,m)
	SNNM.Global_in_Initial_Reset(c,{e3,e5,e6,e6_1})
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,2))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_MOVE)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e9:SetCondition(cm.pcon)
	e9:SetTarget(cm.ptg)
	e9:SetOperation(cm.pop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_CHAINING)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCondition(cm.cpcon)
	e10:SetOperation(cm.record)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,3))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(cm.cpcon)
	e11:SetTarget(cm.cptg)
	e11:SetOperation(cm.cpop)
	c:RegisterEffect(e11)
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp)return c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_DECK) and not c:IsLocation(LOCATION_DECK)end,1,nil,tp) and e:GetHandler():GetSequence()>4
end
function cm.pfilter(c,tp)
	return not c:IsLocation(LOCATION_FZONE) and c:GetOriginalType()&TYPE_FIELD~=0 and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) and c:GetSequence()>4 end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	local tc=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if tc:IsLocation(LOCATION_SZONE) then
			Duel.MoveSequence(tc,5)
			if tc:IsFacedown() then Duel.ChangePosition(tc,POS_FACEUP) end
		else Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSequence()>4 then return false end
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if loc~=LOCATION_MZONE then return false end
	local col=aux.MZoneSequence(seq)
	if p~=tp then col=4-col end
	return aux.GetColumn(c,tp)==col and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_DRAGON)
end
function cm.record(e,tp,eg,ep,ev,re,r,rp)
	local pro1,pro2=re:GetProperty()
	cm[re]={re:GetCategory(),re:GetType(),re:GetCode(),re:GetCost(),re:GetCondition(),re:GetTarget(),re:GetOperation(),pro1,pro2}
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetSequence()<5 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter(c,e,tp)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	SNNM.GoronDimensionCopy(e:GetHandler(),m,cm[re])
	local rc=re:GetHandler()
	if not rc:IsLocation(LOCATION_MZONE) or rc:IsFacedown() then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2)
end
