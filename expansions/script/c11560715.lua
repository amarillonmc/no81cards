--星海航线 逐界苍星
function c11560715.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11560715.mfilter,c11560715.xyzcheck,2,2)
	--ov
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11560715,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11560715)
	e1:SetCondition(c11560715.ovcon) 
	e1:SetTarget(c11560715.ovtg)
	e1:SetOperation(c11560715.ovop)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11560715,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21560715) 
	e2:SetTarget(c11560715.xxtg)
	e2:SetOperation(c11560715.xxop)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1) 
	e3:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()>0 end)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c11560715.discon)
	e4:SetOperation(c11560715.disop)
	--c:RegisterEffect(e4)
end
c11560715.SetCard_SR_Saier=true  
function c11560715.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) 
end
function c11560715.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end


function c11560715.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,rc:GetCode())
end
function c11560715.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c11560715.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end 
function c11560715.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=0
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_GRAVE,1,nil) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_REMOVED,1,nil) then ct=ct+1 end
	local ct=e:GetHandler():RemoveOverlayCard(tp,1,ct,REASON_COST)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c11560715.loccheck(g)
	return g:GetClassCount(Card.GetLocation)==1
end
function c11560715.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanOverlay),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=g:SelectSubGroup(tp,c11560715.loccheck,false,ct,ct)
		Duel.HintSelection(og)
		for tc in aux.Next(og) do
			if tc:IsImmuneToEffect(e) then
				og:RemoveCard(tc)
			else
				tc:CancelToGrave()
			end
		end
	   Duel.Overlay(c,og)
	end
end



function c11560715.mxfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanOverlay()
end
function c11560715.gsfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c11560715.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c11560715.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then 
		local og=c:GetOverlayGroup() 
		local tc=og:Select(tp,1,1,nil):GetFirst() 
		Duel.SendtoGrave(tc,REASON_EFFECT) 
		if tc:IsType(TYPE_MONSTER) then 
				if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c11560715.mxfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(11560715,0)) then 
						Duel.BreakEffect()
					local oc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11560715.mxfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c):GetFirst()  
					if oc and not oc:IsImmuneToEffect(e) then
					oc:CancelToGrave()
		local og=oc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
					Duel.Overlay(c,oc)
					end
				end 
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then 
				if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c11560715.gsfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(11560715,0)) then 
						Duel.BreakEffect()
					local oc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11560715.gsfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c):GetFirst()  
					if oc and not oc:IsImmuneToEffect(e) then
		local og=oc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
					Duel.Overlay(c,oc)
					end
				end 
			 
		end  
	end 
end 





