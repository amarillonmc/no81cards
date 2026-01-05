--星间书抢救司 吉德
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Xyz Procedure
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--Attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.attcon)
	e1:SetTarget(s.atttg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetTargetRange(1,0)
	e2:SetValue(LOCATION_HAND)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(id)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	--Search Opp Deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id+o*2)
	e6:SetCost(s.effcost)
	e6:SetTarget(s.efftg)
	e6:SetOperation(s.effop)
	c:RegisterEffect(e6)
end
function s.attcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_SPELL)
end
function s.attfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsCanOverlay()
end
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.attfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.attfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local xc=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if #g>0 and xc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:Select(tp,1,2,nil)
		Duel.Overlay(xc,sg)
	end
end
function s.repfilter(c,e,tp)
	return e:GetHandler():GetOverlayGroup():IsContains(c) and (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_REMOVED) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.reptg(e,c)
	return c:GetOriginalType()&TYPE_SPELL>0 and c:IsLocation(LOCATION_OVERLAY) and c:GetOverlayTarget()==e:GetHandler() and c:IsType(TYPE_SPELL)
end
function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsControler(1-tp) and e:GetHandler():IsHasEffect(id) then Duel.SendtoHand(tc,tp,REASON_EFFECT) end
	e:SetLabelObject(tc)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if tc then
		Duel.DisableShuffleCheck()
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
	local tc=e:GetLabelObject()
	if tc and tc:GetType()==TYPE_SPELL and tc:IsSetCard(0x3226) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local te=tc:CheckActivateEffect(false,true,false)
			if not te then return end
			local tpe=tc:GetType()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			if tg then
				if tc:IsSetCard(0x3226) then
					tg(e,tp,eg,ep,ev,re,r,rp,1)
				else
					tg(te,tp,eg,ep,ev,re,r,rp,1)
				end
			end
			Duel.BreakEffect()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if not g then g=Group.CreateGroup() end
			for etc in aux.Next(g) do
				etc:CreateEffectRelation(te)
			end
			if op then
				if tc:IsSetCard(0x3226) then
					op(e,tp,eg,ep,ev,re,r,rp)
				else
					op(te,tp,eg,ep,ev,re,r,rp)
				end
			end
			for etc in aux.Next(g) do
				etc:ReleaseEffectRelation(te)
			end
		end
	end
end
