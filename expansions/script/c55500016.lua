--呼唤神之名
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,55500000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,55500000)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x189c,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x189c,4,REASON_COST)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local ac=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	local ty=TYPE_SPELL
	if ac==1 then ty=TYPE_TRAP end
	if ac==2 then ty=TYPE_MONSTER end
	e:SetLabel(ty)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	--wind
	local ty=e:GetLabel()
	local e10=Effect.CreateEffect(e:GetHandler())
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_ACTIVATE_COST)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(0,1)
	e10:SetLabel(ty)
	e10:SetTarget(s.actarget)
	e10:SetCost(s.costchk)
	e10:SetOperation(s.costop)
	e10:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e10,tp)
end

function s.actarget(e,te,tp)
	local ty=e:GetLabel()
	return te:IsActiveType(ty)
end
function s.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,300)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,300)
end

function s.tgfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,55500000)
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCounter(tp,1,0,0x189c)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=Duel.GetFirstTarget()
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,LOCATION_MZONE)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=Duel.GetCounter(tp,1,0,0x189c)*100
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end