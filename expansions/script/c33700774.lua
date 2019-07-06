--妖幻幼精 空无
local m=33700774
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x344a),2,true,true)  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.spcost2)
	e3:SetTarget(cm.sptg2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)
end
function cm.spcfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x344a) and c:IsAbleToDeckAsCost() and (Duel.GetMZoneCount(tp,c,tp)>0 or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.cfilter(c)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x344a) and (c:IsCanBeSpecialSummoned(e,0,tp,true,false) or not c:IsForbidden())
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.spcfilter2,tp,LOCATION_MZONE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
	local ct=g2:GetClassCount(Card.GetCode)
	local g3=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	g1:RemoveCard(tc)
	g3:AddCard(tc)
	if ((Duel.GetMZoneCount(tp,tc,tp)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (Duel.GetLocationCount(tp,LOCATION_SZONE)>1) or g1:IsExists(cm.cfilter,1,nil)) and ct>1 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local g4=g1:Select(tp,1,1,nil)
	   g3:Merge(g4)
	end
	Duel.ConfirmCards(1-tp,g3)
	Duel.SendtoDeck(g3,nil,2,REASON_COST)
	e:SetLabel(g3:GetCount())
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft1+ft2<ct then return end
	local g=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<ct then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		g:RemoveCard(tc)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
		   Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		else
		   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		   local e1=Effect.CreateEffect(c)
		   e1:SetCode(EFFECT_CHANGE_TYPE)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		   tc:RegisterEffect(e1)
		   tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.sprfilter(c,fc)
	return c:IsFusionSetCard(0x344a) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function cm.sprfilter1(c,tp,g)
	return g:IsExists(cm.sprfilter2,1,c,tp,c)
end
function cm.sprfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil,c)
	return g:IsExists(cm.sprfilter1,1,nil,tp,g)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cm.sprfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,cm.sprfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,33700760) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end