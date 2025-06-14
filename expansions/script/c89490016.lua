--炯眼真仙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490015)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(aux.NOT(s.qcon))
	e5:SetCost(s.rcost)
	e5:SetTarget(s.rtg)
	e5:SetOperation(s.rop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(s.qcon)
	c:RegisterEffect(e6)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
function s.atlimit(e,c)
	return c:IsLevel(0) and not c:IsImmuneToEffect(e)
end
function s.efilter(e,te)
	return te:GetOwner():IsLevel(0)
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,89490011)~=nil and c:IsOriginalSetCard(0xc30) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function s.costfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,e:GetHandler())
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_COST)
	if tc:IsSetCard(0xc30) then
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e:SetProperty(e:GetProperty()&~(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN))
	end
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if chk==0 then return #g==5 and g:FilterCount(Card.IsAbleToRemove,nil)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<5 then return end
	Duel.ConfirmDecktop(1-tp,5)
	local g=Duel.GetDecktopGroup(1-tp,5)
	local sg=g:Filter(Card.IsType,nil,1<<e:GetLabel())
	if #sg>0 then
		Duel.DisableShuffleCheck(true)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.thfilter(c)
	return c:IsSetCard(0xc30) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if hg:GetCount()>0 then
		Duel.SendtoHand(hg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
