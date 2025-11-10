--不可见之信徒
local s,id,o=GetID()
function c98920958.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920958,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920958)
	e1:SetTarget(c98920958.thtg)
	e1:SetOperation(c98920958.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--bounce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920958,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c98920958.atcon)
	e3:SetOperation(c98920958.atop)
	c:RegisterEffect(e3)
end
function c98920958.thfilter(c)
	return c:IsSetCard(0x1d3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920958.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920958.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetAttribute)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c98920958.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920958.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetAttribute)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,2,2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
function s.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function c98920958.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	if not a or not d then return false end
	e:SetLabelObject(d)
	return a:IsRace(RACE_ILLUSION)
		and d:IsRelateToBattle() and d:IsOnField()
end
function c98920958.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.GetControl(tc,tp)
	end
end