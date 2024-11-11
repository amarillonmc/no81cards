--炼狱的最亮星
function c98940012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,98940012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98940012.target)
	e1:SetOperation(c98940012.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e3)
--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98940012)
	e2:SetCost(c98940012.thcost)
	e2:SetTarget(c98940012.thtg)
	e2:SetOperation(c98940012.thop)
	c:RegisterEffect(e2)   
end
function c98940012.filter(c,e,tp)
	return c:IsSetCard(0x9c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98940012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98940012.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end
function c98940012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98940012.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)   
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)		
	end   
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98940012,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(7)
	e3:SetCondition(c98940012.con)
	e3:SetCost(c98940012.cost)
	e3:SetTarget(c98940012.tg)
	e3:SetOperation(c98940012.op)
	Duel.RegisterEffect(e3,tp)   
end
function c98940012.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc:IsControler(tp) and rc:IsSetCard(0x9c) and rc:IsType(TYPE_MONSTER)
end
function c98940012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function c98940012.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=re:GetTarget()
	local c=e:GetHandler()
	if chk==0 then
		e:SetProperty(re:GetProperty()&EFFECT_FLAG_CARD_TARGET)
		e:SetLabel(re:GetLabel())
		e:SetLabelObject(re:GetLabelObject())
		return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	end
	e:SetProperty(re:GetProperty()&EFFECT_FLAG_CARD_TARGET)
	e:SetLabel(re:GetLabel())
	e:SetLabelObject(re:GetLabelObject())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(ev)
	e1:SetCondition(c98940012.rscon)
	e1:SetOperation(c98940012.rsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c98940012.rscon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function c98940012.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetProperty(0)
	re:SetLabel(0)
	re:SetLabelObject(nil)
end
function c98940012.op(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c98940012.eftg(e,c)
	return c:IsSetCard(0x132) and c:IsType(TYPE_MONSTER)
end
function c98940012.betg(e,c)
	return c:IsSetCard(0x132) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end
function c98940012.cfilter(c)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsCode(98940012) and c:IsDiscardable()
end
function c98940012.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940012.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c98940012.cfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c98940012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98940012.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end