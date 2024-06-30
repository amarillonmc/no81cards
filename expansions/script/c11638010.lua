local m=11638010
local cm=_G["c"..m]
cm.name="过于依赖术的三下！"
function cm.initial_effect(c)
	aux.AddCodeList(c,11638001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con2)
	e1:SetOperation(cm.activate2)
	c:RegisterEffect(e1)
end
function cm.ninjafilter(c)
	return c:IsFaceup() and c:IsCode(11638001) and c:IsAttackPos()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():GetControler()~=c:GetControler() and Duel.IsExistingMatchingCard(cm.ninjafilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(cm.etarget)
	e3:SetValue(cm.efilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabel(tp)
	e3:SetLabelObject(re)
	Duel.RegisterEffect(e3,tp)
end
function cm.etarget(e,c)
	return (c:IsCode(11638001) or aux.IsCodeListed(c,11638001)) and c:IsFaceup()
end
function cm.efilter(e,re)
	local te=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(te:GetHandler():GetOriginalCodeRule())
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:GetHandler():IsLocation(LOCATION_MZONE) and p~=tp and re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.ninjafilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c2=re:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local c1=Duel.SelectMatchingCard(tp,cm.ninjafilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if c1 and c2 then
		if c2 and c1:IsControler(tp) and c1:IsPosition(POS_FACEUP_ATTACK) and not c2:IsImmuneToEffect(e) and c2:IsControler(1-tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			Duel.HintSelection(Group.FromCards(c1,c2))
			--destroyed
			--local e2=Effect.CreateEffect(c)
			--e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			--e2:SetCode(EVENT_BATTLE_DESTROYED)
			--e2:SetOperation(cm.desop)
			--e2:SetReset(RESET_PHASE+PHASE_END)
			--e2:SetLabel(c2:GetOriginalCodeRule())
			--e2:SetLabelObject(c1)
			--c2:RegisterEffect(e2)
			Duel.CalculateDamage(c1,c2,true)
			Duel.BreakEffect()
			if c2:IsStatus(STATUS_BATTLE_DESTROYED) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e1:SetTarget(cm.distg)
				e1:SetLabel(c2:GetOriginalCodeRule())
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(cm.discon)
				e2:SetOperation(cm.disop)
				e2:SetLabel(c2:GetOriginalCodeRule())
				e2:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)

end
function cm.distg(e,c)
	local code=e:GetLabel()
	return c:IsOriginalCodeRule(code) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(code)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end