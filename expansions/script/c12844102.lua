--业狱火 障目侍
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	aux.AddCodeList(c,12844101)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),4,3,s.ovfilter,aux.Stringid(id,0),3)
	c:EnableReviveLimit()
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLinkCode,12844101))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+100)
	--e5:SetCondition(s.thcon)
	e5:SetCost(s.thcost)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	if not s.global_flag then
		s.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c)
	return c:IsFacedown() or (not c:IsSetCard(0xa77))
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if eg:IsExists(s.cfilter,1,nil) then
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa77) and c:IsType(TYPE_LINK)
end
function s.xyzop(e,tp,chk)
	if chk==0 then 
	local ct=Duel.GetFlagEffect(tp,id+1)
	--Debug.Message(ct)
	return Duel.GetFlagEffect(tp,id)==0 and ct<2 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetFlagEffect(tp,id+1)
	if ct<1 then return false end
	return not c:IsSetCard(0xa77)
end
function s.mfilter(c,e)
	if c~=e:GetHandler() then return false end
	return c:IsLocation(LOCATION_MZONE) 
end
function s.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(12844101)
end
function s.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0xa77) then return false,nil end
	return true,not mg or mg:IsExists(s.mfilter,1,nil,e) 
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4 
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.thfilter(c)
	return c:IsCode(12844101) and c:IsAbleToHand()
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