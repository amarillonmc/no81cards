--无限起动 拉赫米巨人
function c98920751.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920751.matfilter,1,1)
	c:EnableReviveLimit()
	--burial
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920751,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98920751)
	e3:SetCondition(c98920751.tgcon)
	e3:SetTarget(c98920751.tgtg)
	e3:SetOperation(c98920751.tgop)
	c:RegisterEffect(e3)
		--Xmaterial
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920751,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920751.thcon)
	e3:SetOperation(c98920751.thop)
	c:RegisterEffect(e3)
		--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920751,1))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1000)
	e3:SetCondition(c98920751.gfcon)
	c:RegisterEffect(e3)
end
function c98920751.matfilter(c)
	return c:IsLinkSetCard(0x127) and not c:IsLinkType(TYPE_LINK)
end
function c98920751.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98920751.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function c98920751.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920751.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920751.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920751.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local c=e:GetHandler()
	c:RegisterFlagEffect(98920751,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c98920751.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98920751)>0
end
function c98920751.mfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c98920751.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c98920751.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if mg:GetCount()>0 and c:IsLocation(LOCATION_GRAVE) and aux.NecroValleyFilter()(c) and c:IsCanOverlay() and Duel.SelectYesNo(tp,aux.Stringid(98920751,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sc=mg:Select(tp,1,1,nil):GetFirst()
		if not sc:IsImmuneToEffect(e) then
			Duel.Overlay(sc,Group.FromCards(c))
		end
	end
end
function c98920751.gfcon(e)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end