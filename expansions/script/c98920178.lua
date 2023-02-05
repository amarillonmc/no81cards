--破械神 生杀
function c98920178.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,nil,2,nil,c98920178.lcheck)
	c:EnableReviveLimit()   
 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920178,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920178.drcon)
	e2:SetTarget(c98920178.drtg)
	e2:SetOperation(c98920178.drop)
	c:RegisterEffect(e2)	
--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920178,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,98920178)
	e2:SetCondition(c98920178.damcon)
	e2:SetTarget(c98920178.damtg)
	e2:SetOperation(c98920178.damop)
	c:RegisterEffect(e2)	
--atk change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920178,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920178.atkcon)
	e3:SetTarget(c98920178.atktg)
	e3:SetOperation(c98920178.atkop)
	c:RegisterEffect(e3)
end
function c98920178.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c98920178.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function c98920178.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920178.cfilter,1,nil,tp)
end
function c98920178.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920178.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c98920178.cfilter1(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(1-tp)
end
function c98920178.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920178.cfilter1,1,nil,tp)
end
function c98920178.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c98920178.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c98920178.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return (tc and tc:IsFaceup() and tc:GetAttack()>0) or e:GetHandler()==Duel.GetAttackTarget()
end
function c98920178.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
end
function c98920178.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=tc:GetAttack()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e2:SetValue(math.ceil(atk/2))
		c:RegisterEffect(e2)
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(math.ceil(atk/2))
			tc:RegisterEffect(e1)
		end
	end
end