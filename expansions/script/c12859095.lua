--辉极精之秋英宇宙星
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12859055)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.matfilter,3,true)
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1190)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.fuscon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.actcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.matfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttack(900)
end
function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.thfilter(c)
  return c:IsCode(12859055) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #sg==0 then return end
	Duel.HintSelection(sg)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,sg)
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
			if not #sg2==0 then return end
			Duel.HintSelection(sg2)
			Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
		end
	end
end
function s.actcon(e)
	local a=Duel.GetBattleMonster(e:GetHandlerPlayer())
	return a and a:IsFaceup() and a:IsType(TYPE_FUSION) and a:IsRace(RACE_PSYCHO)
end