--MAX-谜之女主角XX
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_DUAL),9,2,s.ovfilter,aux.Stringid(72184387,0),99,s.xyzop)
	c:EnableReviveLimit()
	--overlay
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,72184387)
	e1:SetCondition(s.ovcon)
	e1:SetTarget(s.ovtg)
	e1:SetOperation(s.ovop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.imecon)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72184387,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
s.has_text_type=TYPE_DUAL
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(72184372)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10443957)==0 end
	Duel.RegisterFlagEffect(tp,10443957,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.ofilter(c,e)
	return c:IsSetCard(0x896) and c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if aux.NecroValleyNegateCheck(g) then return end
	local sg=Duel.GetMatchingGroup(s.ofilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	if c:IsRelateToEffect(e) then
		local tc=sg:GetFirst()
		while tc do
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc))
			tc=sg:GetNext()
		end
	end
end
function s.imecon(e)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0x896)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=4
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	tc:RegisterFlagEffect(72184387,RESET_CHAIN,0,1)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil) 
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	Duel.SetTargetCard(Group.FromCards(tc,sc))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sc,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g~=2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext() 
	if tc1:GetFlagEffect(72184387)==0 then tc1=g:GetNext() tc2=g:GetFirst() end
	if tc1:IsAbleToGrave() and tc1:IsType(TYPE_DUAL) and Duel.SelectOption(tp,1191,1192)==1 then
		Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
	else
		Duel.SendtoGrave(tc2,REASON_EFFECT)
	end
end