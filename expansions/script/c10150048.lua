--光之联结
function c10150048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10150048+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(LOCATION_GRAVE)
	e1:SetTarget(c10150048.target)
	e1:SetOperation(c10150048.activate)
	c:RegisterEffect(e1) 
	--sp 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150048,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetLabel(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c10150048.target)
	e2:SetOperation(c10150048.activate)
	c:RegisterEffect(e2)	 
end
function c10150048.filter(c,e,tp)
	local loc,lv=e:GetLabel(),0
	if loc==LOCATION_GRAVE then
	   lv=c:GetLevel()
	   if not lv or lv<8 then return false end
	end
	return Duel.IsExistingMatchingCard(c10150048.spfilter,tp,loc,0,1,nil,e,tp,math.floor(lv/2),c:GetAttribute())
end
function c10150048.spfilter(c,e,tp,lv,att)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(att) and (lv==0 or c:IsLevelBelow(lv))
end
function c10150048.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10150048.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10150048.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c10150048.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetLabel())
end
function c10150048.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc,lv=e:GetLabel(),0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if loc==LOCATION_GRAVE then
	   lv=tc:GetLevel()
	   if not lv or lv<=0 then return end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10150048.spfilter),tp,loc,0,1,1,nil,e,tp,math.floor(lv/2),tc:GetAttribute())
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
