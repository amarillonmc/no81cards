--梦魇剧团团长 格林
local m=115003
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,15000351)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)  
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.valcheck)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	----
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.seqtg)
	e3:SetOperation(cm.seqop)
	c:RegisterEffect(e3) 
	----
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+1000)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) 
end
function cm.xyzcheck(g)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
----
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local flag=0
	if g:IsExists(cm.filters,1,nil) then flag=1 end
	e:SetLabel(flag)
end
function cm.filters(c)
	return (c:IsType(TYPE_LINK) and c:IsRace(RACE_INSECT)) or c:IsOriginalCodeRule(15000351)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
		and e:GetLabelObject():GetLabel()~=0
end
function cm.filter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_INSECT) 
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and   Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Overlay(c,tg)
	end
end
----
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	Duel.BreakEffect()
	local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Destroy(tg,REASON_EFFECT)
end
----
----
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsOriginalCodeRule,1,nil,15000351)
end
function cm.drcfilter2(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:GetOriginalCode()==15000351 
end
function cm.filterxy(c,e,tp)
	return c:IsOriginalCodeRule(m+1) and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(cm.drcfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and Duel.IsExistingMatchingCard(cm.filterxy,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.drcfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SpecialSummon(c,e,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.filterxy,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank()+1)
	local sc=sg:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end