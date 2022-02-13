--虚拟水神忍者
--2022/2/1 remake by VHisc
if not pcall(function() require("expansions/script/c64831501") end) then require("script/c64831501") end
local m,cm=rscf.DefineCard(64831503,"VrAqua")
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m+10000)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and ((rsva.IsSetST(c) and not c:IsType(TYPE_MONSTER)) or (c:IsRace(RACE_CYBERSE) and c:IsLevel(10)))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(cm.descon)
	e1:SetOperation(cm.desop)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return rscon.excard2(rsva.filter_l,LOCATION_MZONE)(e,tp) and loc & LOCATION_MZONE ~=0
end
function cm.desop(e,tp)
	if Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0))
	then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,m)
		rsop.SelectDestroy(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	end
end
function cm.sumfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsSummonable(true,nil)
end