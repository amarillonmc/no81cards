--血染的妖精 芭万·希
local m=72100508
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9a2),4,3)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff)
	e1:SetCost(cm.spcost)
	e1:SetOperation(cm.spcop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)  
	e3:SetCost(cm.descost)
	e3:SetTarget(cm.destg)  
	e3:SetOperation(cm.desop)  
	c:RegisterEffect(e3) 
end
function cm.spcost(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler(),tp,e:GetHandler())
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp)
	if cm.ovcon==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetHandler(),tp,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_CARD,0,m)
		Duel.HintSelection(g)
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc:CancelToGrave()
		Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
	end
end
------
function cm.chainlm(e,ep,tp)
	return tp==ep
end
function cm.cfilter2(c,tp)
	return c:IsSetCard(0x9a2) and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	return eg:IsExists(cm.cfilter2,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(cm.chainlm)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		 if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	end
end
----------
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(cm.chainlm)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.Destroy(g,REASON_RULE)  
	end  
end 
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 