--下界监查粒子
local s,id,o=GetID()
Duel.LoadScript("c33201450.lua")
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.rmcon)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

function s.ovfilter(c)
	return c:IsFaceup() and VHisc_HDST.nck(c) and not c:IsCode(id)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=e:GetHandler():GetOverlayGroup()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetMatchingGroupCount(s.exfilter,tp,0,LOCATION_HAND,nil)>0 end
	local hc=Duel.GetMatchingGroupCount(s.exfilter,tp,0,LOCATION_HAND,nil)
	if rg:GetCount()<hc then hc=rg:GetCount() end
	local ct=e:GetHandler():RemoveOverlayCard(tp,1,hc,REASON_COST)
	e:SetLabel(ct)
end
function s.exfilter(c)
	return not c:IsPublic()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exfilter,tp,0,LOCATION_HAND,1,nil) end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.exfilter,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 and ct then
		local sg=g:RandomSelect(tp,ct)
		Duel.ConfirmCards(tp,sg)
		local tc=sg:GetFirst()
		while tc do
			if VHisc_HDST.nck(tc) then Duel.Destroy(tc,REASON_EFFECT) end
			tc=sg:GetNext()
		end

		local tc2=sg:GetFirst()
		while tc2 do
			if not VHisc_HDST.codeck(VHisc_STCN,tc2) then
				local code=tc2:GetOriginalCode()
				VHisc_STCN[#VHisc_STCN+1]=code
				local fg=Duel.GetMatchingGroup(s.fgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,nil,code)
				for fc in aux.Next(fg) do
					if fc:GetFlagEffect(33201450)==0 then
						fc:RegisterFlagEffect(33201450,nil,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33201450,3))
					end
				end
			end
			tc2=sg:GetNext()
		end
		Duel.ShuffleHand(1-tp)
	end 
end
function s.rmgfilter(c,ndg)
	return ndg:IsExists(Card.IsCode,1,nil,c:GetOriginalCode()) 
end
function s.fgfilter(c,code)
	return c:GetOriginalCode()==code
end


function s.tgfilter(c)
	return VHisc_HDST.nck(c) and c:IsAbleToHand()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end