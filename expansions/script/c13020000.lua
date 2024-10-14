--蒹葭苍苍
local cm, m, ofs = GetID()
local yr = 13020010
xpcall(function() dofile("expansions/script/c16670000.lua") end,function() dofile("script/c16670000.lua") end)
function cm.initial_effect(c)
	aux.AddCodeList(c, yr)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m, 2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(QY_mx)
	e3:SetCountLimit(1, m + 1)
	e3:SetCondition(cm.spcon2)
	e3:SetCost(cm.spcost2)
	e3:SetTarget(cm.sptg2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)
end

function cm.filter(c)
	return aux.IsCodeListed(c, yr) and c:IsAbleToHand()
end
function cm.filter2(c,e,tp)
	return c:IsType(TYPE_EQUIP) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function cm.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.filter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function cm.activate(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, cm.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end

function cm.cfilter(c, tp)
	return c:IsType(TYPE_NORMAL)
end

function cm.spcon2(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(cm.cfilter, 1, nil, tp)
end

function cm.spcost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

function cm.sptg2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_SPELL + TYPE_EQUIP) end
	local kx,zzx,sxx,zzjc,sxjc,zzl=it.sxbl()
	if chk == 0 then return Duel.IsExistingTarget(cm.filter2, tp, LOCATION_GRAVE, 0, 1, nil,e,tp) and zzx>0 end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, cm.filter2, tp, LOCATION_GRAVE, 0, 1, 1, nil,e,tp)
	local zz,sx,lv=it.sxblx(tp,kx,zzx,sxx,zzl)
	e:SetLabel(zz,sx,lv)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function cm.spop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zz,sx,lv=e:GetLabel()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0,TYPE_NORMAL+TYPE_MONSTER,0,0,lv,zz,sx) then return end
		tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_MONSTER,sx,zz,lv,0,0)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e3,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(cm.atkval)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*500
end
function cm.atkfilter(c)
	return aux.IsCodeListed(c, yr) and c:IsType(TYPE_EQUIP)
end





