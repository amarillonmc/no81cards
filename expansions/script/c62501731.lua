--蚀痕无命 命誓厄形·落天流渊
function c62501731.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xea4),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),2,283,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501731.splimit)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501731,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,62501731)
	e3:SetCondition(c62501731.negcon)
	e3:SetCost(c62501731.negcost)
	e3:SetTarget(c62501731.negtg)
	e3:SetOperation(c62501731.negop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501731+1)
	e4:SetTarget(c62501731.rmtg)
	e4:SetOperation(c62501731.rmop)
	c:RegisterEffect(e4)
	c62501731.remove_event_effect=e4
end
function c62501731.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c62501731.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c62501731.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c62501731.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c62501731.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,rc,tp,POS_FACEDOWN)
	if rc:IsRelateToEffect(re) and rc:IsAbleToRemove(tp,POS_FACEDOWN) and g:CheckSubGroup(aux.gfcheck,2,2,Card.IsControler,0,1) and Duel.SelectYesNo(tp,aux.Stringid(62501731,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsControler,0,1)
		Duel.HintSelection(sg)
		sg:AddCard(rc)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c62501731.spfilter(c,e,tp)
	return c:IsSetCard(0xea4) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER) and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED)) and not c:IsCode(62501731) and (Duel.GetMZoneCount(tp)>0 and not c:IsLocation(LOCATION_EXTRA) or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c62501731.gcheck(sg)
	return sg:GetClassCount(Card.GetLocation)==3
end
function c62501731.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,tp,POS_FACEDOWN)
	g:Merge(Duel.GetDecktopGroup(tp,1))
	if chk==0 then return Duel.IsExistingMatchingCard(c62501731.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) and g:CheckSubGroup(c62501731.gcheck,3,3) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED)
end
function c62501731.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,tp,POS_FACEDOWN)
	g:Merge(Duel.GetDecktopGroup(tp,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c62501731.gcheck,false,3,3)
	if rg:GetCount()==0 or Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 or Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c62501731.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
end
