--奥特兄弟·爱迪
function c9951541.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,c9951541.mfilter,10,2,c9951541.ovfilter,aux.Stringid(9951541,1))
	c:EnableReviveLimit()
 c:SetSPSummonOnce(9951541)
--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951541,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c9951541.target)
	e2:SetOperation(c9951541.operation)
	c:RegisterEffect(e2)
  --damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951541,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdgcon)
	e2:SetTarget(c9951541.damtg)
	e2:SetOperation(c9951541.damop)
	c:RegisterEffect(e2)
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951541,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9951541)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9951541.target2)
	e1:SetOperation(c9951541.operation2)
	c:RegisterEffect(e1)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951541.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951541.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951541,0))
end
function c9951541.mfilter(c)
	return c:IsSetCard(0x9bd1) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c9951541.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5bd4) and c:IsLevel(7)
end
function c9951541.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9951541.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951541,2))
end
function c9951541.filter(c,e,tp)
	return c:IsSetCard(0x5bd4) and not c:IsCode(9951541) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951541.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951541.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c9951541.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9951541.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9951541.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if bc:GetAttack() < bc:GetDefense() then dam=bc:GetDefense() end
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c9951541.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951541,2))
end