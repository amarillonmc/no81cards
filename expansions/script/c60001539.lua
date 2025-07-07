--安的巨大英灵
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.spellfil,tp,LOCATION_HAND,0,nil)
		if g then
			for tc in aux.Next(g) do
				if not tc:IsPublic() then
					local e11=Effect.CreateEffect(c)
					e11:SetType(EFFECT_TYPE_SINGLE)
					e11:SetCode(EFFECT_PUBLIC)
					e11:SetReset(RESET_EVENT+RESETS_STANDARD)
					c:RegisterEffect(e11)
				end
				tc:RegisterFlagEffect(60001538,RESET_EVENT+RESET_LEAVE+RESET_TODECK+RESET_TOGRAVE+RESET_REMOVE,0,1)
			end
		end
	end
end