--炼狱骑士团 魔剑处刑龙
function c40009385.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009385,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c40009385.tgcost)
	e1:SetCondition(c40009385.tgcon)
	e1:SetTarget(c40009385.tdtg)
	e1:SetOperation(c40009385.tdop)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009385,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c40009385.sccost)
	e2:SetTarget(c40009385.sctg)
	e2:SetOperation(c40009385.scop)
	c:RegisterEffect(e2)
	--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c40009385.matcon)
	e5:SetOperation(c40009385.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c40009385.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)   
end
function c40009385.tgcfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,0,0,LOCATION_ONFIELD,1,c)
end
function c40009385.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c40009385.tgcfilter,tp,LOCATION_EXTRA,0,1,nil) and c:GetFlagEffect(40009385)<c:GetFlagEffectLabel(40009386)  end
	c:RegisterFlagEffect(40009385,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40009385.tgcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40009385.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(40009386) and e:GetHandler():GetFlagEffectLabel(40009386)>0
end
function c40009385.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function c40009385.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c40009385.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function c40009385.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(40009386,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c40009385.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsFusionType,nil,TYPE_SYNCHRO)
	e:GetLabelObject():SetLabel(ct)
end
function c40009385.sccfilter(c)
	if c:IsFacedown() or not c:IsAbleToRemoveAsCost() then return false end
	return c:IsType(TYPE_SYNCHRO) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c40009385.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c40009385.sccfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,5,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40009385.sccfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,5,5,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40009385.scfilter(c,e,tp)
	return c:IsSetCard(0xf14) and c:IsLevel(12) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c40009385.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c40009385.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009385.scop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009385.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end


