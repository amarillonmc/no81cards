--万相曲形卡席尔
function c87531015.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,3,c87531015.ovfilter,aux.Stringid(87531015,0),3,c87531015.xyzop)
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87531015,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c87531015.con)
	e2:SetCost(c87531015.cost)
	e2:SetTarget(c87531015.tg)
	e2:SetOperation(c87531015.op)
	c:RegisterEffect(e2)
end
function c87531015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c87531015.cfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER)
end
function c87531015.ovfilter(c)
	if Duel.GetMatchingGroupCount(c87531015.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)<5 then return false end
	return c:IsFaceup() 
end
function c87531015.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,87531015)==0 end
	Duel.RegisterFlagEffect(tp,87531015,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c87531015.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c87531015.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,3,nil)
end
function c87531015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetMatchingGroupCount(c87531015.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)>6 then
		Duel.SetChainLimit(c87531015.chlimit)
	end
end
function c87531015.chlimit(e,ep,tp)
	return tp==ep
end
function c87531015.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c87531015.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if ct>=3 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*400)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(87531015,3))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(ct*400)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2)
	end
	if ct>=5 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetDescription(aux.Stringid(87531015,4))
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e4)
	end
	if ct>=7 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetValue(aux.tgoval)
		e5:SetRange(LOCATION_MZONE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e5)
		local e10=Effect.CreateEffect(c)
		e10:SetDescription(aux.Stringid(87531015,5))
		e10:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e10)
	end
	if ct>=9 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(87531015,2))
		e6:SetCategory(CATEGORY_RECOVER)
		e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e6:SetCode(EVENT_BATTLE_DAMAGE)
		e6:SetCondition(c87531015.recon)
		e6:SetTarget(c87531015.retg)
		e6:SetOperation(c87531015.reop)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(87531015,6))
		e7:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e7)
		--pierce
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_PIERCE)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e10)
	end
	if ct>=11 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e8=Effect.CreateEffect(c)
		e8:SetDescription(aux.Stringid(87531015,7))
		e8:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_EXTRA_ATTACK)
		e8:SetValue(1)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_DIRECT_ATTACK)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e9)
	end
end
function c87531015.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c87531015.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c87531015.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c87531015.dircon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return not c:IsStatus(STATUS_SPSUMMON_TURN)
end