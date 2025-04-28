--常伴神将身旁之人 塞内利奥
local cm,m,o=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--battle target lock
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.lvtg)
	e1:SetOperation(cm.lvop)
	c:RegisterEffect(e1)
	--battle atkup
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)   
	e1:SetCountLimit(1,m+10000000)  
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())	
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(cm.bttg)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
	end
end
function cm.bttg(e,c)
	return c~=e:GetHandler() 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=e:GetHandler():GetOverlayGroup()
	local ct=g:GetCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--atk change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1,m+20000000)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetCondition(cm.atkcon)
	--e3:SetTarget(cm.atktg)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.atkop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)	
	--draw(battle)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1,m+30000000)
	e3:SetCondition(cm.drcon)
	e3:SetOperation(cm.drop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsFaceup()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle(e) or c:IsFacedown() or tc:IsFacedown() or not tc:IsRelateToBattle(e) then return end
	if c:IsRelateToBattle(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		local atk2=tc:GetAttack()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e2:SetValue(math.ceil(atk/2))
		c:RegisterEffect(e2)
		if tc:IsFaceup() and tc:IsRelateToBattle(e) and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(math.ceil(atk2/2))
			tc:RegisterEffect(e1)
		end
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,math.ceil(ev/2),REASON_EFFECT)
end