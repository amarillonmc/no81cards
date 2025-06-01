--六合精工 商鞅方升
local s,id,o=GetID()
Duel.LoadScript("c33201370.lua")
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.retcon)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e2)
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(0x200)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
s.VHisc_HYZQ=true
s.VHisc_CNTreasure=true

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetHandler():GetOverlayGroup()
	local tc=re:GetHandler()
	return re:GetHandler()~=e:GetHandler() and re:GetHandler():IsType(TYPE_SPELL+TYPE_RITUAL) and ep==tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and tc.VHisc_HYZQ and rg:GetCount()>0
end
function s.matfilter(c)
	return c:IsCanOverlay() and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local rg1=e:GetHandler():GetOverlayGroup()
	if rg1:GetCount()>0 then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_RELEASE)
		local rg2=e:GetHandler():GetOverlayGroup()
		if rg2:GetCount()==0 and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
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

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return VHisc_CNTdb.spck(e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		if Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
			if g:GetCount()>0 then
				Duel.Overlay(e:GetHandler(),g)
			end
		end
	end
end