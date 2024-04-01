--渊洋海战
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsSetCard(0x223) and c:GetOverlayCount()>0 and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and c:IsFaceup()
		and c:GetOverlayGroup():IsExists(s.tgfilter,1,nil)
end
function s.tgfilter(c)
	return c:IsSetCard(0x3223) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsLocation(LOCATION_GRAVE) and not c:IsReason(REASON_REDIRECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local c=e:GetHandler()
	local g=tc:GetOverlayGroup()
	local max=g:FilterCount(s.tgfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:FilterSelect(tp,s.tgfilter,1,max,nil)
	if #tg<=0 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tg:FilterCount(aux.NecroValleyFilter(s.spfilter),nil,e,tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:FilterSelect(tp,aux.NecroValleyFilter(s.spfilter),1,Duel.GetLocationCount(tp,LOCATION_MZONE),nil,e,tp)
		for sc in aux.Next(sg) do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			sc:RegisterEffect(e1)
			sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		Duel.SpecialSummonComplete()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(sg)
		e2:SetCondition(s.ovcon)
		e2:SetOperation(s.ovop)
		Duel.RegisterEffect(e2,tp)
		sg:KeepAlive()
	end
end
function s.ovcfilter(c)
	return c:GetFlagEffect(id)~=0
end
function s.xyztfilter(c)
	return c:IsSetCard(0x223) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if sg:FilterCount(s.ovcfilter,nil)>0 then
		return true
	else
		e:Reset()
		sg:DeleteGroup()
		return false
	end
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.ovcfilter,nil)
	local tmp=Group.CreateGroup()
	for sc in aux.Next(sg) do
		local og=sc:GetOverlayGroup()
		if og:GetCount()>0 then
			tmp:Merge(og)
		end
	end
	if #tmp>0 then
		Duel.SendtoGrave(tmp,REASON_RULE)
	end
	if Duel.IsExistingMatchingCard(s.xyztfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local c=Duel.SelectMatchingCard(tp,s.xyztfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.Overlay(c,sg)
	else
		Duel.SendtoGrave(sg,REASON_RULE)
	end
	g:DeleteGroup()
	e:Reset()
end

function s.thfilter(c)
	return c:IsSetCard(0x3223) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
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