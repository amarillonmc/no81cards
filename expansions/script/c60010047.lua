--摇篮鸹
local cm,m,o=GetID()
function cm.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():CheckActivateEffect(false,true,false)~=nil
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	if Duel.ChangeChainOperation(ev,cm.repop)~=0 and re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		local te=ec:GetActivateEffect()
		if ec:IsType(TYPE_FIELD) then
			Duel.MoveToField(ec,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.RaiseEvent(ec,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.MoveToField(ec,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end 
		te:UseCountLimit(tp,1,true)
		cm.ActivateCard(ec,tp,e)
		if (not (ec:IsType(TYPE_CONTINUOUS) or ec:IsType(TYPE_FIELD) or ec:IsType(TYPE_EQUIP))) and ec:IsRelateToEffect(e) then
			 Duel.SendtoGrave(ec,REASON_RULE)
		end
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	
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
		--if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
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