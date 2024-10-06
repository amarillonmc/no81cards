--灭剑焰龙·双极模式α
function c60010245.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c60010245.splimit)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c60010245.destg)
	e1:SetOperation(c60010245.desop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,60010245)
	e2:SetCondition(c60010245.imcon)
	e2:SetTarget(c60010245.imtg)
	e2:SetOperation(c60010245.imop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c60010245.condition)
	e3:SetOperation(c60010245.operation)
	c:RegisterEffect(e3)
end
function c60010245.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c60010245.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c60010245.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function c60010245.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(60002134)~=0
end
function c60010245.imfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup()
end
function c60010245.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60010245.imfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c60010245.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.IsExistingMatchingCard(c60010245.imfilter,tp,LOCATION_MZONE,0,1,c)
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if #g==0 then return end
	if Duel.SelectOption(tp,aux.Stringid(60010245,0),aux.Stringid(60010245,1))==0 then
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
		--atk
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e3:SetValue(1000)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e4)
		for tc in aux.Next(g) do
			--indes2
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_IMMUNE_EFFECT)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			e5:SetValue(c60010245.efilter)
			e5:SetOwnerPlayer(tp)
			tc:RegisterEffect(e5)
		end
	else
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c60010245.efilter)
		e1:SetOwnerPlayer(tp)
		c:RegisterEffect(e1)
		for tc in aux.Next(g) do
			--indes2
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			tc:RegisterEffect(e3)
			--atk
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_ATTACK)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetValue(1000)
			tc:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e5)
		end
	end
end
function c60010245.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActivated()
end
function c60010245.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c60010245.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex1=Effect.CreateEffect(e:GetHandler())
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ex1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	ex1:SetTargetRange(1,0)
	ex1:SetValue(1)
	ex1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(ex1,true,tp)
	return ex1
end
