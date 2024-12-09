--狩猎游戏-野犬
function c12877065.initial_effect(c)
	--pendulum and fusion
	aux.EnablePendulumAttribute(c,false)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c12877065.matfilter,2,false)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c12877065.splimit)
	c:RegisterEffect(e0)
	--moster effect
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12877065,3))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c12877065.cost)
	e1:SetTarget(c12877065.thtg)
	e1:SetOperation(c12877065.thop)
	c:RegisterEffect(e1)
	--pzone move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12877065,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12877065)
	e2:SetTarget(c12877065.settg)
	e2:SetOperation(c12877065.setop)
	c:RegisterEffect(e2)
	--pendulum effect
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12877065,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,12877066)
	e3:SetCost(c12877065.spcost)
	e3:SetTarget(c12877065.sptg)
	e3:SetOperation(c12877065.spop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c12877065.recon)
	e4:SetOperation(c12877065.reop)
	c:RegisterEffect(e4)
end
--fusion and procedure
function c12877065.matfilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x9a7b) and not c:IsFusionType(TYPE_FUSION)
end
function c12877065.splimit(e,se,sp,st)
	return not (e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFacedown())
end
function c12877065.costfilter(c,atk)
	return c:IsReleasable() and c:IsSetCard(0x9a7b) and c:IsAttackAbove(atk)
end
function c12877065.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12877065.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e:GetHandler():GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c12877065.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e:GetHandler():GetAttack())
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function c12877065.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9a7b) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c12877065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12877065.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c12877065.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12877065.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c12877065.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c12877065.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c12877065.rlcheck(mg,tp)
	return Duel.GetMZoneCount(tp,mg)>0 and (#mg==1 and mg:IsExists(Card.IsLevel,1,nil,10) and mg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) or #mg==2)
end
function c12877065.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c12877065.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),tp)
	if chk==0 then return #mg>0 and mg:CheckSubGroup(c12877065.rlcheck,1,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,c12877065.rlcheck,false,1,2,tp)
	Duel.Release(sg,REASON_COST)
end
function c12877065.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c12877065.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c12877065.recon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and rc:IsSetCard(0x9a7b)
end
function c12877065.reop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.Recover(tp,rc:GetBaseAttack()/2,REASON_EFFECT)
end
