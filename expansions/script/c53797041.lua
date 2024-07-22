local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local f=Duel.AnnounceType
		Duel.AnnounceType=function(p)
			local type=f(p)
			Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1,1<<type)
			return type
		end
	end
end
function s.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,5) or c:IsXyzLevel(xyzc,6)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local type,t=0,{Duel.GetFlagEffectLabel(tp,id)}
	for _,v in ipairs(t) do type=type|v end
	return type==0x7
end
function s.filter(c,type)
	return c:IsType(type) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil,TYPE_MONSTER) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil,TYPE_SPELL) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil,TYPE_TRAP) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil,TYPE_SPELL)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil,TYPE_TRAP)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,6,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local sg1=g2:Select(tp,math.max(0,3-#g1),#g2,nil)
		local sg2=g1:RandomSelect(tp,3-#sg1)
		sg1:Merge(sg2)
		if #sg1>0 then Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT) end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(2000) and c:IsRace(RACE_ZOMBIE) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.dfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.dfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
