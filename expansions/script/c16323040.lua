--异甲同心 马尔修斯 毁灭×坚壁
function c16323040.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,16323030,16323025,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(c16323040.splimit)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e11)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e12:SetRange(LOCATION_MZONE)
	e12:SetValue(c16323040.efilter)
	c:RegisterEffect(e12)
	--immune effect
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c16323040.immunefilter)
	c:RegisterEffect(e13)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16323040)
	e2:SetTarget(c16323040.destg)
	e2:SetOperation(c16323040.desop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16323040+1)
	e3:SetCondition(c16323040.negcon)
	e3:SetTarget(c16323040.negtg)
	e3:SetOperation(c16323040.negop)
	c:RegisterEffect(e3)
end
function c16323040.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c16323040.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsType,Card.IsFaceup),tp,0,0xc,nil,re:GetHandler():GetType())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,1-tp,0xc)
end
function c16323040.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsType,Card.IsFaceup),tp,0,0xc,nil,re:GetHandler():GetType())
	if #g>0 then
		Duel.Destroy(g,0x40)
	end
end
function c16323040.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xc,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0xe,0,1,nil) and #dg>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0xe)
end
function c16323040.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xc,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0xe,0,1,math.min(3,#dg),nil)
	if #g>0 then
		Duel.HintSelection(g)
		local int=Duel.Destroy(g,REASON_EFFECT)
		if int>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,int,int,nil)
			if #g2>0 then
				Duel.HintSelection(g2)
				Duel.Destroy(g2,REASON_EFFECT)
			end
		end
		if int>=2 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
		if int>=3 then
			--act limit
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_ACTIVATE)
			e3:SetCondition(c16323040.con)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(0,1)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
		end
	end
end
function c16323040.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c16323040.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
		and te:GetHandler():IsRace(0x20)
end
function c16323040.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetHandlerPlayer()~=re:GetHandlerPlayer()
		and re:GetHandler():IsRace(0x20)
end
function c16323040.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x3dcf) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end