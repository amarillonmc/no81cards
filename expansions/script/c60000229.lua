--菲-引导员-
Duel.LoadScript("c60000228.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	Rotta.handeff(c,cm.tgtg,cm.tgop)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x3624) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfil,tp,LOCATION_REMOVED,0,3,nil)
	and #Duel.GetDecktopGroup(tp,1)~=0 and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.rmfil,tp,LOCATION_REMOVED,0,3,nil) or not c:IsAbleToDeck() or #Duel.GetDecktopGroup(tp,1)==0 then return end
	local dg=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.rmfil,tp,LOCATION_REMOVED,0,3,3,nil)
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end

function cm.rmfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function cm.fcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	local tf=false
	local facedown=c:GetFlagEffect(code)
	local faceup=c:GetFlagEffect(code+10000000)
	if faceup+facedown==0 then
		if c:IsPublic() then c:RegisterFlagEffect(code+10000000,RESET_EVENT+RESETS_STANDARD,0,1)
		else c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1) end
	elseif facedown==1 then
		if c:IsPublic() then
			c:ResetFlagEffect(code)
			c:RegisterFlagEffect(code+10000000,RESET_EVENT+RESETS_STANDARD,0,1)
			tf=true
		end
	elseif faceup==1 then
		if not c:IsPublic() then
			c:ResetFlagEffect(code+10000000)
			c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
	Debug.Message(tf)
	return tf
end











