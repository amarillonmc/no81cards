--墨菲定律
--21.08.05
local m=11451607
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	--top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DRAW)
	e2:SetCost(cm.tpcost)
	e2:SetTarget(cm.tptg)
	e2:SetOperation(cm.tpop)
	c:RegisterEffect(e2)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.drcon1)
	e1:SetOperation(cm.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(cm.drcon2)
	e3:SetOperation(cm.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.filter(c)
	return c:IsSetCard(0x12e) and c:IsPreviousLocation(LOCATION_HAND)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil) and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m)
	Duel.ResetFlagEffect(tp,m)
	Duel.Draw(tp,n*2,REASON_EFFECT)
end
function cm.filter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
end
function cm.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
end
function cm.tpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local rg=g:SelectSubGroup(tp,aux.dncheck,false,1,99)
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
		local tg=rg:GetMinGroup(Card.GetSequence)
		while tg and #tg>0 do
			local tc=tg:GetFirst()
			Duel.MoveSequence(tc,0)
			rg:RemoveCard(tc)
			tg=rg:GetMinGroup(Card.GetSequence)
		end
	end
end