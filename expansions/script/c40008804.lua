--时间侠盗 追缉者
function c40008804.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x126),4,2)
	c:EnableReviveLimit()
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008804,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40008804.mattg)
	e1:SetOperation(c40008804.matop)
	c:RegisterEffect(e1)   
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008804,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,40008804)
	e2:SetTarget(c40008804.target)
	e2:SetOperation(c40008804.operation)
	c:RegisterEffect(e2)
end
function c40008804.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
end
function c40008804.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	if c:IsRelateToEffect(e) and g:GetCount()==1 then
		Duel.Overlay(c,g)
	end
end
function c40008804.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c40008804.matfilter(c,tp)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c40008804.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ng=Group.CreateGroup()
		local dg=Group.CreateGroup()
		if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return false end
		local g=c:GetOverlayGroup()
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
			and Duel.IsExistingMatchingCard(c40008804.posfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
			and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) and Duel.IsExistingMatchingCard(c40008804.matfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) then return true end
		return false
	end
end
function c40008804.check2(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c40008804.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local g=c:GetOverlayGroup()
	local tg=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(c40008804.posfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_MONSTER))
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_SPELL))
	end
	if Duel.IsExistingMatchingCard(c40008804.matfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_TRAP))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=tg:SelectSubGroup(tp,c40008804.check2,false,1,3)
	if not sg then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	if sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local pg=Duel.SelectMatchingCard(tp,c40008804.posfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		Duel.SendtoDeck(pg,nil,2,REASON_EFFECT)
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
		Duel.BreakEffect()
	local ag=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local cg=ag:RandomSelect(1-tp,1)
	Duel.SendtoGrave(cg,REASON_DISCARD+REASON_EFFECT)
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
		Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local gg=Duel.SelectMatchingCard(tp,c40008804.matfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
	if gg:GetCount()>=0 then
		Duel.Overlay(e:GetHandler(),gg)
	end
	end
end
