--星坠尘 心斩
local m=14000280
local cm=_G["c"..m]
cm.card_code_list={14000260}
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,nil,1)
	c:EnableReviveLimit()
	--burn and remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.stg)
	e1:SetOperation(cm.sop)
	c:RegisterEffect(e1)
end
function cm.ffilter(c)
	return c:IsFaceup() and c:IsCode(14000260)
end
function cm.rmfilter(c,e)
	return c:IsAbleToRemove() and c:IsLocation(LOCATION_MZONE) and (not e or c:IsRelateToEffect(e)) and c:IsPreviousLocation(LOCATION_HAND)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,sg=e:GetHandler(),eg:Filter(cm.rmfilter,nil)
	if chk==0 then return #sg>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	if #sg~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
	end
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c,sg=e:GetHandler(),eg:Filter(cm.rmfilter,nil,e)
	if Duel.Damage(1-tp,1000,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.ffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		local tc=sg:GetFirst()
		while tc do
			if tc:IsFaceup() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			tc=sg:GetNext()
		end
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end