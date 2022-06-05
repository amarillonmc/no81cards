--混沌的圣域
local m=10888912
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.cbttg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(cm.tkco)
	e3:SetTarget(cm.tktg)
	e3:SetOperation(cm.tkop)
	e3:SetLabel(0)
	c:RegisterEffect(e3)
end

function cm.cbttg(e,c)
	return c:IsSetCard(0x773)
end

function cm.tgtfilter(c)
	return c:IsSetCard(0x773) and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.cotkfilter(c)
	return c:IsSetCard(0x773) and c:IsType(TYPE_MONSTER) and c:IsReleasable() and c:IsLevelAbove(0) 
	and not c:IsType(TYPE_TOKEN)
end

function cm.tkco(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end

function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,cm.cotkfilter,1,nil,e,tp) 
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,cm.cotkfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local level=tc:GetPreviousLevelOnField()
	local att=tc:GetPreviousAttributeOnField()
	if tc:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10888933,0x773,TYPES_TOKEN_MONSTER,0,0,level,RACE_WYRM,att) 
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local token=Duel.CreateToken(tp,10888933)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(level)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(att)
		token:RegisterEffect(e2)
		end
	end
	Duel.SpecialSummonComplete()
end