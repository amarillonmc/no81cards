local m=15006315
local cm=_G["c"..m]
cm.name="绝情阴蛊-同心"
function cm.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.sscon)
	e1:SetTarget(cm.sstg)
	e1:SetOperation(cm.ssop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(cm.ss2con)
	c:RegisterEffect(e2)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(cm.atkcon)
	e0:SetCost(cm.cost)
	e0:SetTarget(cm.atktg)
	e0:SetOperation(cm.atkop)
	c:RegisterEffect(e0)
	--tohand
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_BATTLE_DESTROYING)
	e00:SetCondition(cm.upcon)
	e00:SetOperation(cm.upop)
	c:RegisterEffect(e00)
	if not YinguxiangcanCheck then
		YinguxiangcanCheck=true
		local _YinguxiangcanCalculateDamage=Duel.CalculateDamage
		function Duel.CalculateDamage(c1,c2,newattack)
			if not newattack then newattack=false end
			if c1:GetControler()==c2:GetControler() and (c1:IsHasEffect(EFFECT_REFLECT_BATTLE_DAMAGE) or c2:IsHasEffect(EFFECT_REFLECT_BATTLE_DAMAGE)) then
				if not c1:IsHasEffect(EFFECT_REFLECT_BATTLE_DAMAGE) then
					local e1=Effect.CreateEffect(c2)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
					e1:SetValue(1)
					c1:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c2)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_CUSTOM+15006319)
					e2:SetRange(LOCATION_MZONE)
					e2:SetOperation(cm.atkresop)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
					e2:SetLabelObject(e1)
					c1:RegisterEffect(e2)
				end
				if not c2:IsHasEffect(EFFECT_REFLECT_BATTLE_DAMAGE) then
					local e3=Effect.CreateEffect(c1)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
					e3:SetValue(1)
					c2:RegisterEffect(e3)
					local e4=Effect.CreateEffect(c1)
					e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e4:SetCode(EVENT_CUSTOM+15006319)
					e4:SetRange(LOCATION_MZONE)
					e4:SetOperation(cm.atkresop)
					e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
					e4:SetLabelObject(e3)
					c2:RegisterEffect(e4)
				end
			end
			_YinguxiangcanCalculateDamage(c1,c2,newattack)
			Duel.RaiseEvent(Group.FromCards(c1,c2),EVENT_CUSTOM+15006319,e1,0,0,0,0)
		end
	end
end
function cm.atkresop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function cm.ss2con(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsRelateToBattle()
end
function cm.setfilter(c)
	return c:IsSetCard(0x3f45) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,tp,LOCATION_DECK)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(tp,g:GetFirst())==0 then return end
		if g:GetFirst():IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
		if g:GetFirst():IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and Duel.GetCurrentChain()==0
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,e:GetHandler(),TYPE_MONSTER) and e:GetHandler():IsPosition(POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),TYPE_MONSTER)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local atc=Duel.GetFirstTarget()
	if atc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsPosition(POS_FACEUP_ATTACK) then
		Duel.CalculateDamage(e:GetHandler(),atc)
	end
end
function cm.upcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function cm.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(300)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
end