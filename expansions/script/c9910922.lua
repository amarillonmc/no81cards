--金迷匪魔
function c9910922.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--effect draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	e2:SetCondition(c9910922.drcon)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9910922)
	e3:SetTarget(c9910922.damtg)
	e3:SetOperation(c9910922.damop)
	c:RegisterEffect(e3)
end
function c9910922.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function c9910922.drcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9910922.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910922.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
	if Duel.GetCurrentChain()>1 then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(CATEGORY_DAMAGE)
	end
end
function c9910922.thfilter(c,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsSetCard(0x3954)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand(tp)
end
function c9910922.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910922.thfilter),tp,LOCATION_DECK,LOCATION_GRAVE,nil,tp)
	if Duel.Damage(1-tp,300,REASON_EFFECT)~=0 and Duel.GetCurrentChain()>1 and #g>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910922,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
