--末氏空骨 救赎
function c33330503.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33330503.covcost)
	e1:SetTarget(c33330503.covtg)
	e1:SetOperation(c33330503.covop)
	c:RegisterEffect(e1)
	--overskeleton!!!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33330503)
	e2:SetCondition(c33330503.skcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33330503.sktg)
	e2:SetOperation(c33330503.skop)
	c:RegisterEffect(e2)
end
function c33330503.ccostfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(1)
end
function c33330503.covcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c33330503.ccostfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c33330503.ccostfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local lv=g:GetFirst():GetLevel()
	e:SetLabel(lv)
end
function c33330503.covtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(lv*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,lv*500)
end
function c33330503.covop(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c33330503.skconfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c33330503.skcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c33330503.skconfil,tp,LOCATION_MZONE,0,1,nil)
end
function c33330503.skfil(c,e,tp)
	return c:IsSetCard(0x5552) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33330503.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33330503.skfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c33330503.skop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33330503.skfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
