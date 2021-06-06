local m=82208136
local cm=_G["c"..m]
cm.name="桃花石国桃花源"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.spcon1)
	e1:SetCost(cm.spcost1)  
	e1:SetTarget(cm.sptg1)  
	e1:SetOperation(cm.spop1)  
	c:RegisterEffect(e1)  
	--damage 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetCategory(CATEGORY_DAMAGE)  
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m+10000)   
	e3:SetCost(cm.damcost)  
	e3:SetTarget(cm.damtg)  
	e3:SetOperation(cm.damop)  
	c:RegisterEffect(e3) 
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==0x04 or Duel.GetCurrentPhase()==0x100
end
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return not e:GetHandler():IsPublic() end  
end  
function cm.spfilter1(c,e,tp)  
	return c:IsRace(RACE_PYRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function cm.spop1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)  
		e1:SetValue(TYPE_XYZ)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_ABSOLUTE_TARGET+EFFECT_FLAG_CANNOT_DISABLE) 
		e2:SetCode(EVENT_CHAINING)  
		e2:SetRange(LOCATION_MZONE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e2:SetCondition(cm.regcon)
		e2:SetOperation(cm.regop)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)  
		local e3=Effect.CreateEffect(c)  
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_ABSOLUTE_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_CHAIN_SOLVED)  
		e3:SetRange(LOCATION_MZONE)  
		e3:SetCondition(cm.overlaycon)  
		e3:SetOperation(cm.overlayop)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)  
		Duel.SpecialSummonComplete()
	end  
end  
function cm.regcon(e)
	return e:GetHandler():IsType(TYPE_XYZ)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	if rp==tp then return end  
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)  
end  
function cm.overlaycon(e,tp,eg,ep,ev,re,r,rp)   
	return ep~=tp and e:GetHandler():GetFlagEffect(m)~=0 and Duel.IsExistingMatchingCard(nil,1-tp,0x0e,0,1,e:GetHandler()) and e:GetHandler():IsType(TYPE_XYZ)
end  
function cm.overlayop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,m)  
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,0x0e,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc:CancelToGrave()
		Duel.Overlay(e:GetHandler(),g)
	end
end  
function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsAbleToHandAsCost,1,nil) end  
	local g=c:GetOverlayGroup():Filter(Card.IsAbleToHandAsCost,nil):Select(tp,1,99,nil)
	e:SetLabel(g:GetCount())  
	Duel.SendtoHand(g,tp,REASON_COST)
end  
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local ct=e:GetLabel()  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	local ct=e:GetLabel()  
	Duel.Damage(p,ct*500,REASON_EFFECT)  
end  