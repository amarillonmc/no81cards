local m=53799208
local cm=_G["c"..m]
cm.name="狐假虎威·石卷"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,m+500)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK+LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(1-tp,function(c)return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()end,1-tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(function(c,atk)return c:IsType(TYPE_MONSTER) and c:GetAttack()>atk and c:IsAbleToGrave()end,tp,LOCATION_DECK,0,nil,tc:GetAttack())
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(math.abs(sc:GetAttack()-tc:GetAttack()))
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
				e:GetHandler():RegisterEffect(e1)
			end
		end
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()<e:GetHandler():GetAttack() and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_GRAVE~=0
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0) end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then Duel.Remove(eg,POS_FACEUP,REASON_EFFECT) end
end
