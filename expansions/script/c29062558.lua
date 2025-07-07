--方舟骑士团·燃血
local m=29062558
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)	
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayCount(tp,LOCATION_ONFIELD,0)>0 and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.ovcheck(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local ovcg=Duel.SelectMatchingCard(tp,cm.ovcheck,tp,LOCATION_MZONE,0,1,1,nil)
		if ovcg:GetCount()>0 then
			Duel.HintSelection(ovcg)
			local ovc=ovcg:GetFirst()
			local ovg=ovc:GetOverlayGroup()
			local ct=ovg:GetCount()
			local ft=g:GetCount()
			if ct>ft then
				ct=ft
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local num=ovc:RemoveOverlayCard(tp,1,ct,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local cg=g:Select(tp,num,num,nil)
			if cg:GetCount()>0 then
				Duel.HintSelection(cg)
			end
			for tc in aux.Next(cg) do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x87af) and c:IsType(TYPE_XYZ)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
