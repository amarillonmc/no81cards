--N公司 浮士德
local m=43990060
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,c43990060.mfilter,1,1)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c43990060.condition)
	e1:SetOperation(c43990060.regop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c43990060.thcon)
	e2:SetTarget(c43990060.thtg)
	e2:SetOperation(c43990060.thop)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_MACHINE)
	e3:SetTarget(c43990060.rctg)
	c:RegisterEffect(e3)
	
end
function c43990060.rctg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c43990060.mfilter(c)
	return c:IsLinkSetCard(0x3510)
end
function c43990060.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c43990060.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c43990060.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c43990060.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(43990060) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c43990060.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c43990060.thfilter(c)
	return c:IsCode(43990057) and c:IsAbleToHand()
end
function c43990060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990060.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43990060.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c43990060.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
