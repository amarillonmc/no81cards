-- 无尽的滑坡 / Pendio Senzafondo
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.chaincon)
	e2:SetCost(s.chaincost)
	e2:SetTarget(s.chaintg)
	e2:SetOperation(s.chainop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		BottomlessSlopeRes={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		--EP damage
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE+PHASE_END)
		ge2:SetCountLimit(1)
		ge2:SetOperation(s.damop)
		Duel.RegisterEffect(ge2,0)
		--negate
		local ge3=Effect.CreateEffect(c)
		ge3:SetDescription(aux.Stringid(id,2))
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
		ge3:SetCode(EFFECT_DISABLE)
		ge3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		ge3:SetTarget(s.distg)
		Duel.RegisterEffect(ge3,0)
		--adjust to GY
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge4,0)
		--skip MP1
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD)
		ge5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge5:SetCode(EFFECT_SKIP_M1)
		ge5:SetTargetRange(1,0)
		ge5:SetCondition(s.skipcon0)
		Duel.RegisterEffect(ge5,0)
		local ge5x=ge5:Clone()
		ge5x:SetCode(EFFECT_SKIP_M2)
		ge5x:SetTargetRange(1,0)
		Duel.RegisterEffect(ge5x,0)
		local ge5y=ge5:Clone()
		ge5y:SetTargetRange(0,1)
		ge5y:SetCondition(s.skipcon1)
		Duel.RegisterEffect(ge5y,0)
		local ge5z=ge5x:Clone()
		ge5z:SetTargetRange(0,1)
		ge5z:SetCondition(s.skipcon1)
		Duel.RegisterEffect(ge5z,0)
		--resolution count
		if not aux.ToResetFuncTable then
			aux.ToResetFuncTable = {function() BottomlessSlopeRes={} end}
			local ge=Effect.GlobalEffect()
			ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge:SetCode(EVENT_TURN_END)
			ge:SetCountLimit(1)
			ge:SetCondition(s.ValuesReset)
			Duel.RegisterEffect(ge,0)
		else
			table.insert(aux.ToResetFuncTable,function() BottomlessSlopeRes={} end)
		end
	end
end
function s.ValuesReset()
	for _,v in pairs(Auxiliary.ToResetFuncTable) do
		v()
	end
	return false
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsCode(id) then return end
	table.insert(BottomlessSlopeRes,re:GetHandler():GetFieldID())
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if #BottomlessSlopeRes==0 then return end
	local val = #BottomlessSlopeRes * 500
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Damage(tp,val,REASON_EFFECT)
end

function s.filter(c)
	return c:IsCode(id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.chaincost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.chaintg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE,1)
		if tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:IsLocation(LOCATION_MZONE) and (tc:GetAttack()>0 or tc:GetDefense()>0) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
	end
end

function s.distg(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:GetFlagEffect(id)>=3
end
function s.adjfilter(c,ct)
	return c:GetFlagEffect(id)>=ct
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(s.adjfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,7)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_RULE)
		Duel.Readjust()
	end
end
function s.totaltg(g)
	return g:GetSum(Card.GetFlagEffect,id)>=13
end
function s.skipcon0(e)
	local g=Duel.GetMatchingGroup(s.adjfilter,e:GetOwnerPlayer(),LOCATION_ONFIELD,0,nil,0)
	return g:CheckSubGroup(s.totaltg,1,#g)
end
function s.skipcon1(e)
	local g=Duel.GetMatchingGroup(s.adjfilter,e:GetOwnerPlayer(),0,LOCATION_ONFIELD,nil,0)
	return g:CheckSubGroup(s.totaltg,1,#g)
end