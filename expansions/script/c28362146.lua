--最初的闪耀
function c28362146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c28362146.con)
	e1:SetTarget(c28362146.target)
	e1:SetOperation(c28362146.activate)
	c:RegisterEffect(e1)
end
function c28362146.cfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c28362146.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28362146.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil)
end
function c28362146.filter(c)
	return c:IsCode(28315548) and c:IsFaceup()
end
function c28362146.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28362146.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28362146.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28362146.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c28362146.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=Duel.GetMatchingGroupCount(c28362146.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if ct>=3 then
			--atk
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
			--indes
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(aux.tgoval)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28362146,0))
		end
		if ct>=16 then
			--indes2
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetValue(c28362146.efilter)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28362146,1))
		end
		if ct>=28 then
			--disable
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
			e5:SetType(EFFECT_TYPE_QUICK_O)
			e5:SetCode(EVENT_CHAINING)
			e5:SetCountLimit(1)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCondition(c28362146.discon)
			e5:SetTarget(c28362146.distg)
			e5:SetOperation(c28362146.disop)
			tc:RegisterEffect(e5)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28362146,2))
		end
	end
end
function c28362146.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c28362146.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c28362146.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function c28362146.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp)
	if Duel.NegateEffect(ev) and #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
