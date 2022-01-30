--晦空士梦死所 | Garage Seppiavita
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableCounterPermit(0x144e)
	c:SetCounterLimit(0x144e,1)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetCost(s.ctcost)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(s.desreptg)
	e5:SetOperation(s.desrepop)
	c:RegisterEffect(e5)
	--skip oppo turn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.skipcon)
	e3:SetCost(s.skipcost)
	e3:SetTarget(s.skiptg)
	e3:SetOperation(s.skipop)
	c:RegisterEffect(e3)
end
function s.excfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x144e)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not Duel.IsExistingMatchingCard(s.excfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x144e) and c:IsAbleToDeckOrExtraAsCost()
end
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,4,4)
	aux.GCheckAdditional=nil
	Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x144e,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,1,0x144e)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetTurnPlayer()
	Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
	--
	local e2x=Effect.CreateEffect(e:GetHandler())
	e2x:SetType(EFFECT_TYPE_FIELD)
	e2x:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2x:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2x:SetLabel(Duel.GetTurnCount())
	e2x:SetCondition(s.trcon)
	e2x:SetTargetRange(1,1)
	e2x:SetValue(1)
	Duel.RegisterEffect(e2x,p)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetLabelObject(e2x)
	e2:SetCondition(s.trcon)
	e2:SetOperation(s.trop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,p)
end
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.GetTurnCount()==e:GetLabel()
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() and e:GetLabelObject().GetLabelObject then
		e:GetLabelObject():Reset()
	end
	if e:GetOwner():IsFaceup() and e:GetOwner():IsCanAddCounter(0x144e,1) then
		e:GetOwner():AddCounter(0x144e,1)
	end
	e:Reset()
end

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x144e)>0 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x144e,1,REASON_EFFECT)
end

function s.skipcon(e,tp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x144e,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x144e,1,REASON_COST)
end
function s.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function s.skipop(e,tp,eg,ep,ev,re,r,rp)
	local rct=(Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END) and 2 or 1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct)
	Duel.RegisterEffect(e1,tp)
end