--六合精工 良渚玉琮王
local m=33201358
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201350") end,function() require("script/c33201350") end)
function cm.initial_effect(c)
	VHisc_CNTdb.the(c,m,0x100000+0x80000+0x40+0x20,0x10000)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sthtg)
	e2:SetOperation(cm.sthop)
	c:RegisterEffect(e2)
end
cm.VHisc_CNTreasure=true

--e2
function cm.thfilter(c)
	return VHisc_CNTdb.nck(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.sthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.sthop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		local tc=tg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetTarget(cm.atktg)
		e1:SetValue(1000)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function cm.atktg(e,c)
	return c:GetCode()==e:GetLabel()
end

--e0
function cm.tgfilter(c)
	return c:IsAbleToGrave() and not c:IsLocation(LOCATION_FZONE)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_SZONE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.SendtoGrave(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then 
				Duel.BreakEffect()
				local tc=g:GetFirst()
				local typ=tc:GetOriginalType()
				if bit.band(typ,TYPE_MONSTER)~=0 then
					Duel.DiscardDeck(tp,3,REASON_EFFECT)
				end
				if bit.band(typ,TYPE_SPELL)~=0 then
					Duel.Recover(tp,1000,REASON_EFFECT)
				end
				if bit.band(typ,TYPE_TRAP)~=0 then
					Duel.Damage(1-tp,1000,REASON_EFFECT)
				end
			end
		end
	end
end