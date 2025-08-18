--炯眼皇鼎龙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490096)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1102)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(aux.NOT(s.qcon))
	e5:SetCost(s.rcost)
	e5:SetTarget(s.rtg)
	e5:SetOperation(s.rop)
	c:RegisterEffect(e5)
	local e55=e5:Clone()
	e55:SetType(EFFECT_TYPE_QUICK_O)
	e55:SetCode(EVENT_FREE_CHAIN)
	e55:SetCondition(s.qcon)
	c:RegisterEffect(e55)
end
function s.atlimit(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsImmuneToEffect(e)
end
function s.efilter(e,te)
	local tc=te:GetOwner()
	return tc:IsSummonType(SUMMON_TYPE_SPECIAL) and tc:GetControler()~=e:GetOwnerPlayer()
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,89490011)~=nil and c:IsOriginalSetCard(0xc30) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function s.costfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.tgfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.rlfilter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe1=Duel.IsPlayerAffectedByEffect(tp,89490052)
	local b1=fe1 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local fe2=Duel.IsPlayerAffectedByEffect(tp,89490080)
	local b2=fe2 and Duel.IsExistingMatchingCard(s.rlfilter,tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.CheckReleaseGroup(tp,s.costfilter,1,e:GetHandler())
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,{b1,fe1 and fe1:GetDescription() or nil},{b2,fe2 and fe2:GetDescription() or nil},{b3,e:GetDescription()})
	if op==1 then
		Duel.Hint(HINT_CARD,0,89490052)
		fe1:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==2 then
		Duel.Hint(HINT_CARD,0,89490080)
		fe2:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
		if tc:IsSetCard(0xc30) then
			e:SetProperty(e:GetProperty()|EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
		else
			e:SetProperty(e:GetProperty()&~(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN))
		end
	else
		local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,e:GetHandler())
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
		if tc:IsSetCard(0xc30) then
			e:SetProperty(e:GetProperty()|EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
		else
			e:SetProperty(e:GetProperty()&~(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN))
		end
	end
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) or #g>0 and g:GetFirst():IsAbleToRemove(tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct>5 then ct=5 end
	if ct>1 then
		local tbl={}
		for i=1,ct do
			table.insert(tbl,i)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94392192,3))
		ct=Duel.AnnounceNumber(tp,table.unpack(tbl))
	end
	local g3=Duel.GetDecktopGroup(1-tp,ct)
	local cg=g1+g2+g3
	if #cg<=0 then return end
	Duel.ConfirmCards(tp,cg:Filter(Card.IsFacedown,nil))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.RevealSelectDeckSequence(true)
	local sg=cg:FilterSelect(tp,Card.IsAbleToRemove,1,3,nil,tp)
	Duel.RevealSelectDeckSequence(false)
	if #sg>0 then
		Duel.DisableShuffleCheck(true)
		local rct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		if rct>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,rct*1000,REASON_EFFECT)
		end
	end
end
