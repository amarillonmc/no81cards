--恩底弥翁的魔导兽使
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	c:EnableReviveLimit()
	--apply the effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	
end
function s.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_SPELLCASTER)
end
function s.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=0
	if c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x10d)>0 then flag=flag|1 end
	if c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x12a)>0 then flag=flag|2 end
	e:GetLabelObject():SetLabel(flag)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thfilter(c)
	return c:IsSetCard(0x12a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return c:IsSetCard(0x10d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chk1=e:GetLabel()&1>0
	local chk2=e:GetLabel()&2>0
	if chk==0 then return (chk1 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil))
		or (chk2 and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)) end
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk1=e:GetLabel()&1>0
	local chk2=e:GetLabel()&2>0
	local sg=Group.CreateGroup()
	if chk1 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		sg:Merge(g)
	end
	if chk2 then
		local g2=Duel.GetMatchingGroup(s.thfilter2,tp,LOCATION_DECK,0,nil)
		sg:Merge(g2)
	end
	if #sg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=sg:Select(tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.filter(c)
	return c:IsAbleToHand()
end
function s.thfilter3(c)
	return c:IsCode(38943357,94599451) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if Duel.IsExistingMatchingCard(s.thfilter3,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter3,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
