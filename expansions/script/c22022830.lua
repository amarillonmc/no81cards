--人理之基 魔神总司
function c22022830.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22020690,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2ff1),1,true,true)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022830,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22022830)
	e1:SetTarget(c22022830.mattg)
	e1:SetOperation(c22022830.matop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022830,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c22022830.mattg)
	e2:SetOperation(c22022830.matop)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022830,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,22022831)
	e3:SetTarget(c22022830.target)
	e3:SetOperation(c22022830.operation)
	c:RegisterEffect(e3)
end
function c22022830.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c22022830.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,3)
	if c:IsRelateToEffect(e) and g:GetCount()==3 then
		Duel.DisableShuffleCheck()
		Duel.Overlay(c,g)
	end
end
function c22022830.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22022830.filter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c22022830.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return false end
		local g=c:GetOverlayGroup()
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
			and Duel.IsExistingMatchingCard(c22022830.filter,tp,0,LOCATION_ONFIELD,1,c) then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
			and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP)
			 then return true end
		return false
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c22022830.check(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c22022830.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg1=Duel.GetMatchingGroup(c22022830.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local sg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if not c:IsRelateToEffect(e) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local g=c:GetOverlayGroup()
	local tg=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(c22022830.filter,tp,0,LOCATION_ONFIELD,1,nil) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_MONSTER))
	end
	if Duel.IsExistingMatchingCard(c22022830.filter1,tp,0,LOCATION_MZONE,1,nil) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_SPELL))
	end
	if c:IsFaceup() and not c:IsAttack(7500) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_TRAP))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=tg:SelectSubGroup(tp,c22022830.check,false,1,3)
	if not sg then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	if sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		Duel.BreakEffect()
		Duel.Destroy(sg1,REASON_EFFECT)
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
		Duel.BreakEffect()
		Duel.Destroy(sg2,REASON_EFFECT)
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(7500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end