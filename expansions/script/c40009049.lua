--伏魔忍鬼 清姬
function c40009049.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x2b),1)
	c:EnableReviveLimit()   
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009049,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,40009049)
	e1:SetCost(c40009049.spcost)
	e1:SetTarget(c40009049.target)
	e1:SetOperation(c40009049.activate)
	c:RegisterEffect(e1)
	--damage after destroying
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009049,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c40009049.damtg1)
	e2:SetOperation(c40009049.damop1)
	c:RegisterEffect(e2)
end
function c40009049.costfilter(c,tp)
	return c:IsSetCard(0x61) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c40009049.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009049.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40009049.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40009049.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x2b)
		and Duel.IsExistingMatchingCard(c40009049.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c40009049.filter2(c,code,e,tp)
	return c:IsCode(code) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsSummonable(true,nil))
end
function c40009049.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009049.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c40009049.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40009049,1))
	Duel.SelectTarget(tp,c40009049.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40009049.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(40009049,3)) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local g=Duel.SelectMatchingCard(tp,c40009049.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
		 if g:GetCount()>0 then
		 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		 end
	  else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		 local g=Duel.SelectMatchingCard(tp,c40009049.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
		 if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.Summon(tp,tc,true,nil)
		 end
	end
end
function c40009049.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c40009049.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end