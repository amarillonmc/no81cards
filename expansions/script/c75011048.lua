--红莲之刃 派翠夏·阿贝尔海姆
function c75011048.initial_effect(c)
	c:SetSPSummonOnce(75011048)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75e),4,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--summon reg
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(c75011048.regcon)
	e0:SetOperation(c75011048.regop)
	c:RegisterEffect(e0)
	--add effect
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(0,TIMING_END)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75011048.efcon)
	e4:SetCost(c75011048.efcost)
	e4:SetTarget(c75011048.eftg)
	e4:SetOperation(c75011048.efop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c75011048.efcon)
	e5:SetTarget(c75011048.damtg)
	e5:SetOperation(c75011048.damop)
	c:RegisterEffect(e5)
end
function c75011048.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c75011048.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75011048,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75011048,3))
end
function c75011048.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(75011048)~=0
end
function c75011048.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then return ct>0 and e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function c75011048.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetLP(1-tp)<Duel.GetLP(tp) then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else e:SetProperty(0) end
end
function c75011048.efop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetLabel(0)
	e1:SetCondition(c75011048.arcon)
	e1:SetOperation(c75011048.arop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75011048.arcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function c75011048.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c75011048.arop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==0 then e:SetLabel(1) return end
	Duel.Hint(HINT_CARD,0,75011048)
	if ct==1 then
		e:SetLabel(2)
		if Duel.Damage(1-tp,200,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil,tp)
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	elseif ct==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c75011048.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
		e:Reset()
	end
end
function c75011048.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=math.max(math.floor((8000-Duel.GetLP(1-tp))/5),100)
	Duel.SetTargetPlayer(1-tp)
	--Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
	if Duel.GetLP(1-tp)<Duel.GetLP(tp) then
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else e:SetProperty(EFFECT_FLAG_PLAYER_TARGET) end
end
function c75011048.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val=math.max(math.floor((8000-Duel.GetLP(1-tp))/5),100)
	Duel.Damage(p,val,REASON_EFFECT)
end
