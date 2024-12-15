--异种 吞食者
function c98500160.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500160,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98500160)
	e1:SetCondition(c98500160.condition)
	e1:SetCost(c98500160.cost)
	e1:SetTarget(c98500160.target)
	e1:SetOperation(c98500160.operation)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500160,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500161)
	e2:SetTarget(c98500160.hsptg)
	e2:SetOperation(c98500160.hspop)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500160,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98500162)
	e3:SetTarget(c98500160.destg)
	e3:SetOperation(c98500160.desop)
	c:RegisterEffect(e3)
end
function c98500160.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and tp~=ep and Duel.GetCurrentChain()==0
end
function c98500160.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(98500160,9),aux.Stringid(98500160,10))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c98500160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c98500160.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if Duel.ConfirmCards(tp,g2)~=0 then
		Duel.ShuffleHand(1-tp)
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
		if g:GetCount()>0 then
			Duel.NegateSummon(eg)
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c98500160.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500160.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500160.filter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (e:GetHandler():IsSummonable(true,nil) or e:GetHandler():IsMSetable(true,nil)) and (Duel.IsExistingTarget(c98500160.filter3,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,16104622) and Duel.IsExistingTarget(c98500160.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsPlayerAffectedByEffect(tp,16104622) then
		local g=Duel.SelectTarget(tp,c98500160.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		local g=Duel.SelectTarget(tp,c98500160.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c98500160.filter4(c)
	return c:IsFacedown()
end
function c98500160.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return false end
	local ts={}
	local index=1
	if e:GetHandler():IsSummonable(true,nil) then
		ts[index]=aux.Stringid(98500160,7)
		index=index+1
	end
	if e:GetHandler():IsMSetable(true,nil) then
	   ts[index]=aux.Stringid(98500160,8)
	   index=index+1
	end
	local c=e:GetHandler()
	local opt=Duel.SelectOption(tp,table.unpack(ts))
	if ts[opt+1]==aux.Stringid(98500160,7) then
		Duel.Summon(tp,c,true,nil)
	elseif ts[opt+1]==aux.Stringid(98500160,8) then
		Duel.MSet(tp,c,true,nil)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_ONFIELD,0)
			e1:SetTarget(c98500160.tg)
			e1:SetValue(c98500160.efilter)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c98500160.tg(e,c)
	return c:IsFacedown()
end
function c98500160.efilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end
function c98500160.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c98500160.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #dg>0 then
		local dc=dg:GetFirst()
		while dc do
			local atk=dc:GetAttack()
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(math.ceil(atk/2))
			dc:RegisterEffect(e2)
			dc=dg:GetNext()
		end
	end
end
