local m=15006319
local cm=_G["c"..m]
cm.name="阴蛊相残"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.rftg)
	e2:SetOperation(cm.rfop)
	c:RegisterEffect(e2)
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
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP
end
function cm.atkfilter1(c,tp)
	return c:IsFaceup() and c:IsAttackPos()
		and Duel.IsExistingTarget(cm.atkfilter2,tp,LOCATION_MZONE,0,1,c)
end
function cm.atkfilter2(c)
	return c:IsFaceup()
end
function cm.atkgcheck(g)
	return g:FilterCount(Card.IsFaceup,nil)==#g and g:IsExists(Card.IsAttackPos,1,nil)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.atkfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=g:SelectSubGroup(tp,cm.atkgcheck,false,2,2)
	Duel.SetTargetCard(tg)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:FilterCount(Card.IsFaceup,nil)==2 then
		if g:FilterCount(Card.IsAttackPos,nil)==0 then return end
		if g:FilterCount(Card.IsAttackPos,nil)==1 then
			local atc=g:Filter(Card.IsAttackPos,nil):GetFirst()
			g:RemoveCard(atc)
			local attc=g:GetFirst()
			Duel.CalculateDamage(atc,attc)
		end
		if g:FilterCount(Card.IsAttackPos,nil)==2 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			local atc=g:Select(tp,1,1,nil):GetFirst()
			g:RemoveCard(atc)
			local attc=g:GetFirst()
			Duel.CalculateDamage(atc,attc)
		end
	end
end
function cm.rffilter(c)
	return c:IsSetCard(0x3f45) and c:IsFaceup()
end
function cm.rftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.rffilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.rffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rffilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.rffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.rfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--reflect battle dam
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end