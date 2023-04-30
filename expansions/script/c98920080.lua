--娱乐伙伴 异色眼围巾龙
function c98920080.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c98920080.synlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c98920080.reg)
	c:RegisterEffect(e1)
   --draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,98920080)
	e2:SetCondition(c98920080.drcon)
	e2:SetTarget(c98920080.drtg)
	e2:SetOperation(c98920080.drop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetCondition(c98920080.atkcon)
	e3:SetValue(c98920080.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	e4:SetValue(c98920080.defval)
	c:RegisterEffect(e4) 
   --destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c98920080.condition)
	e5:SetCountLimit(1,98930080)
	e5:SetTarget(c98920080.target)
	e5:SetOperation(c98920080.operation)
	c:RegisterEffect(e5)
end
function c98920080.defval(e,c)
	return c:GetBaseDefense()*2
end
function c98920080.atkval(e,c)
	return c:GetBaseAttack()*2
end
function c98920080.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c98920080.atkcon(e)
	return Duel.IsExistingMatchingCard(c98920080.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c98920080.synlimit(e,c)
	if not c then return false end
	return not c:IsType(TYPE_PENDULUM)
end
function c98920080.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(98920080,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98920080.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98920080)~=0
end
function c98920080.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920080.tgfilter(c)
	return c:IsSetCard(0x9f) and c:IsType(TYPE_PENDULUM)
end
function c98920080.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.ShuffleHand(p)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(p,c98920080.tgfilter,p,LOCATION_HAND,0,1,1,nil)
	local tg=g:GetFirst()
	if tg then
		if Duel.SendtoExtraP(g,nil,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,tg)
			Duel.ShuffleHand(p)
		end
	else
		local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		if Duel.SendtoGrave(sg,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		end
	end
end
function c98920080.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c98920080.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x9f) and c:IsType(TYPE_PENDULUM)
end
function c98920080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920080.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26237713,0))
	local g1=Duel.SelectTarget(tp,c98920080.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c98920080.operation(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local c=e:GetHandler()
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc==hc then tc=g:GetNext() end
		if hc:IsRelateToEffect(e) and hc:IsControler(tp)
			and Duel.SendtoExtraP(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_EXTRA)
			and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end