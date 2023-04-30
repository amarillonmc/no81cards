--六合精工 五彩十二花卉杯
local m=33201359
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201350") end,function() require("script/c33201350") end)
function cm.initial_effect(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.VHisc_CNTreasure=true

--e1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PUBLIC)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	--send to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetLabel(0)
	e1:SetTarget(cm.sthtg)
	e1:SetOperation(cm.sthop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function cm.thfilter(c,e,tp)
	return VHisc_CNTdb.nck(c) and c:IsAbleToHand() and (c:IsLevelBelow(e:GetHandler():GetLevel()) or VHisc_CNTdb.spck(e,tp))
end
function cm.sthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.sthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		e:SetLabel(e:GetLabel()+1)
		local ct=tg:GetFirst():GetLevel()
		if c:GetLevel()>ct then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_UPDATE_LEVEL)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e0:SetValue(-ct)
			c:RegisterEffect(e0)
		else
			if VHisc_CNTdb.spck(e,tp) then
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_CHANGE_LEVEL)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e0:SetValue(1)
				c:RegisterEffect(e0)
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
				if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetLabel()>0
					and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabel(),nil)
					Duel.HintSelection(dg)
					Duel.Destroy(dg,REASON_EFFECT)
				end
			end
		end 
	end
end

