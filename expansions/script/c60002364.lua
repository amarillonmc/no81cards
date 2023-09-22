--古神在上
local cm,m,o=GetID()
function cm.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function cm.afil(c,rc)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:CheckActivateEffect(false,false,false)~=nil and not c:IsCode(rc)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT) then
			local rc=re:GetCode()
			local g4=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK,nil,rc)
			if Duel.IsExistingMatchingCard(cm.afil,tp,0,LOCATION_DECK,1,g4) then
				local g=Duel.GetMatchingGroup(cm.afil,tp,0,LOCATION_DECK,g4):RandomSelect(tp,1,1,nil):GetFirst()
				if g:IsType(TYPE_FIELD) then
					local te=g:GetActivateEffect()
					Duel.MoveToField(g,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
					Duel.RaiseEvent(g,4179255,te,0,tp,tp,Duel.GetCurrentChain())
				else
					local te=g:GetActivateEffect()
					Duel.MoveToField(g,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
				end 
				te:UseCountLimit(1-tp,1,true)
				cm.ActivateCard(g,1-tp,e)
				if not (g:IsType(TYPE_CONTINUOUS) or g:IsType(TYPE_FIELD) or g:IsType(TYPE_EQUIP)) then
					Duel.SendtoGrave(g,REASON_RULE)
				end
			else
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		end
	end
end
function cm.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end




