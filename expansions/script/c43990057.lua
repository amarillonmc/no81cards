--异端的审判所
local m=43990057
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c43990057.cgcon)
	e2:SetOperation(c43990057.cgop)
	c:RegisterEffect(e2)
	--dss
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,43990057)
	e3:SetTarget(c43990057.target)
	e3:SetOperation(c43990057.operation)
	c:RegisterEffect(e3)
end
function c43990057.cgcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return not rc:IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rc:IsControler(1-tp)
end
function c43990057.cgop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRace(RACE_MACHINE) and rc:IsFaceup() then
			Duel.Hint(HINT_CARD,0,43990057)
			if rc:IsLocation(LOCATION_MZONE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_MACHINE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1) end
	end
end
function c43990057.thfilter(c)
	return c:IsSetCard(0x3510) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c43990057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c43990057.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43990057.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c43990057.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c43990057.smfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_WARRIOR)
end
function c43990057.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c43990057.smfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990057,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,c43990057.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	end
end
