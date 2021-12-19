--极光战姬 塞拉丝怀特
local m=40009611
local cm=_G["c"..m]
cm.named_with_Seraph=1
cm.named_with_AuroraBattlePrincess=1
function cm.AuroraBattlePrincess(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AuroraBattlePrincess
end
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()   
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009612)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.ovfilter(c)
	return c:IsFaceup() and cm.AuroraBattlePrincess(c) and c:IsType(TYPE_XYZ) and c:IsRank(3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay() 
end
function cm.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.xctgfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,2,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(cm.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if g0:GetCount()>0 and tg:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,cm.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local tc=g2:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 and not tc:IsImmuneToEffect(e) then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,tg)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.xctgfilter,tp,LOCATION_FZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) then
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		   local g1=tc:GetOverlayGroup()
		   if g1:GetCount()==0 then return end
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		   local mg=g1:Select(tp,1,1,nil)
		   local oc=mg:GetFirst():GetOverlayTarget()
		   Duel.Overlay(c,mg)
		   Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
	end
end





