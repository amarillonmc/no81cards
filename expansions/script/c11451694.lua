--猎龙者的挽歌
local m=11451694
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(cm.damcost)
	e3:SetTarget(cm.damtg)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsRace(RACE_DRAGON+RACE_WARRIOR) and (c:IsAttack(2300) or c:IsDefense(2300)) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsSetCard(0xd6)) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and not c:IsForbidden()
end
function cm.mfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsFaceup()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cfilter,nil)
	local g2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=#g and #g>0 and #g2>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if #g>0 and #g2>0 and ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tg=g2:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		if #g>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g=g:Select(tp,ft,ft,nil)
		end
		for qc in aux.Next(g) do
			if not Duel.Equip(tp,qc,tc,false,true) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			qc:RegisterEffect(e1)
		end
		Duel.EquipComplete()
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.rfilter(c)
	return c:IsCode(21970285) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:GetEquipGroup():GetClassCount(Card.GetCode)>=3
end
function cm.ncostfilter(c)
	return not c:IsAbleToGraveAsCost()
end
function cm.dfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_DRAGON)
end
function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil) and #g>0 and not g:IsExists(cm.ncostfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil)
	Duel.Release(rg,REASON_COST)
	g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	Duel.SendtoGrave(g,REASON_COST)
	local ct=g:FilterCount(cm.dfilter,nil)
	e:SetLabel(ct)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(38955728) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()*500)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Damage(1-tp,e:GetLabel()*500,REASON_EFFECT)
	end
end