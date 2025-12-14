--星间书统领司 艾杰拉
local s,id,o=GetID()
function s.initial_effect(c)
	--Xyz Procedure
	aux.AddXyzProcedureLevelFree(c,s.xyzfilter,nil,2,2)
	c:EnableReviveLimit()
	--Excavate and Attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.attcost)
	e1:SetTarget(s.atttg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)
	--Unaffected
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3226))
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--Negate Spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(s.negcon)
	e3:SetCost(s.negcost)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end
function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()==1 
		and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SPELL)
end
function s.attcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 
		and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsType,TYPE_XYZ),tp,LOCATION_MZONE,0,1,nil) end
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		local mg=g:Filter(Card.IsType,nil,TYPE_SPELL)
		if #mg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local xg=Duel.SelectMatchingCard(tp,aux.FilterBoolFunction(Card.IsType,TYPE_XYZ),tp,LOCATION_MZONE,0,1,1,nil)
			local xc=xg:GetFirst()
			if xc then
				Duel.Overlay(xc,mg)
				g:Sub(mg)
			end
		end
		if #g>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local tc=re:GetHandler()
		if tc and (tc:GetOriginalType()&TYPE_SPELL)~=0 and tc:IsRelateToEffect(re) then
			if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				local te=tc:CheckActivateEffect(false,true,false)
				if not te then return end
				local tpe=tc:GetType()
				local tg=te:GetTarget()
				local op=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				Duel.ClearTargetCard()
				if tg then
					if tc:IsSetCard(0x3226) then
						tg(e,tp,eg,ep,ev,re,r,rp,1)
					else
						tg(te,tp,eg,ep,ev,re,r,rp,1)
					end
				end
				Duel.BreakEffect()
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if not g then g=Group.CreateGroup() end
				for etc in aux.Next(g) do
					etc:CreateEffectRelation(te)
				end
				if op then
					if tc:IsSetCard(0x3226) then
						op(e,tp,eg,ep,ev,re,r,rp)
					else
						op(te,tp,eg,ep,ev,re,r,rp)
					end
				end
				for etc in aux.Next(g) do
					etc:ReleaseEffectRelation(te)
				end
			end
		end
	end
end
