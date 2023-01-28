--破浪航船 财宝号
local s,id,o=GetID()
Duel.LoadScript("c33201150.lua")
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit() 
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+10000)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

--xyz
function s.ovfilter(c)
	return c:IsFaceup() and c.VHisc_Mermaid and c:IsLevel(4) and c:IsRace(RACE_WARRIOR) and c:IsCanOverlay()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,2,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,2,2,nil)
	for mc in aux.Next(g) do
		local mg=mc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(c,mg)
		end
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end

--e1
function s.setfilter(c)
	return c.VHisc_Mermaid and not c:IsForbidden()
end
function s.matfilter(c)
	return c:IsCanOverlay() and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and og:FilterCount(s.setfilter,nil)>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup():Filter(s.setfilter,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and og:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sc=og:Select(tp,1,1,nil):GetFirst()
		Mermaid_VHisc.sp(sc,tp)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(s.matfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(tp,s.matfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
			if g:GetCount()>0 then
				for mc in aux.Next(g) do
					local mg=mc:GetOverlayGroup()
					if mg:GetCount()~=0 then
						Duel.Overlay(e:GetHandler(),mg)
					end
				end
				Duel.Overlay(e:GetHandler(),g)
			end
		end
	end
end

--e2
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.thfilter(c)
	return c:IsCode(33201154) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end