--禁约之黑魔术师
function c72411530.initial_effect(c)
	aux.AddCodeList(c,72411270)
		--pendulum summon
	aux.EnablePendulumAttribute(c)
		--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetValue(72411270)
	c:RegisterEffect(e0)
	--halve damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c72411530.val)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(72411530,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c72411530.discon)
	e2:SetTarget(c72411530.distg)
	e2:SetOperation(c72411530.disop)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72411530,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,72411530)
	e3:SetCondition(c72411530.drcon)
	e3:SetTarget(c72411530.drtg)
	e3:SetOperation(c72411530.drop)
	c:RegisterEffect(e3)
		if not c72411530.global_check then
			c72411530.global_check=true
			c72411530[0]=0
			c72411530[1]=0
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_DESTROYED)
			ge1:SetOperation(c72411530.checkop)
			Duel.RegisterEffect(ge1,0)
		end

end
function c72411530.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:GetPreviousControler()==tp and tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsCode(72411270) then
			local p=tc:GetControler()
			c72411530[p]=c72411530[p]+1
		end
		tc=eg:GetNext()
	end
end
function c72411530.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c72411530[tp]>0
end
function c72411530.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
end
function c72411530.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c72411530[tp]*600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
	Duel.BreakEffect()
	Duel.Damage(1-tp,math.floor(c:GetAttack()/2),REASON_EFFECT)
end
function c72411530.val(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end
function c72411530.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c72411530.filter1(c)
	return c:IsCode(72411270) and c:IsFaceup() 
end
function c72411530.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c72411530.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72411530.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c72411530.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end