local m=15006316
local cm=_G["c"..m]
cm.name="邪尾阴蛊-玄蝎"
function cm.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(cm.spcon)
	e0:SetCost(cm.cost)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.atkcon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_BATTLE_DESTROYING)
	e00:SetCondition(cm.upcon)
	e00:SetOperation(cm.upop)
	c:RegisterEffect(e00)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
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
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and Duel.GetCurrentChain()==0
end
function cm.f(c)
	return c:IsSetCard(0x3f45) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() and chkc:IsSetCard(0x3f45) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(cm.f,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetMZoneCount(tp,e:GetHandler())>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.f,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp,e:GetHandler())<0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(tc:GetLevel()*200)
		c:RegisterEffect(e1)
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and Duel.GetCurrentChain()==0
end
function cm.ff(c)
	return c:IsSetCard(0x3f45) and c:IsType(TYPE_MONSTER)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() and chkc:IsSetCard(0x3f45) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(cm.ff,tp,LOCATION_MZONE,0,1,e:GetHandler()) and e:GetHandler():IsPosition(POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.ff,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
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
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end