--邪遗式术师·艾米莉娅
function c76372772.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EVENT_TO_DECK)
	e0:SetCondition(c76372772.xyzcon)
	e0:SetOperation(c76372772.xyzop)
	c:RegisterEffect(e0)
	--ritual
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76372772,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,76372772)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c76372772.ricost)
	e1:SetTarget(c76372772.ritg)
	e1:SetOperation(c76372772.riop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76372772,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,76372773)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c76372772.cost)
	e2:SetTarget(c76372772.target)
	e2:SetOperation(c76372772.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76372772,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,76372774)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c76372772.cost)
	e3:SetTarget(c76372772.target2)
	e3:SetOperation(c76372772.operation2)
	c:RegisterEffect(e3)
end
function c76372772.mfilter(c,tp,xyzc,re)
	return Duel.GetLocationCountFromEx(tp,tp,c,TYPE_XYZ)>0 and not c:IsCode(76372772) and (re:GetHandler():IsSetCard(0x3a) or c:IsSetCard(0x3a))
end
function c76372772.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c76372772.mfilter,1,nil,tp,e:GetHandler(),re) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function c76372772.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then return end
	if Duel.GetFlagEffect(tp,76372772)==0 and Duel.SelectYesNo(tp,aux.Stringid(76372772,0)) then
		Duel.ConfirmCards(1-tp,c)
		local mg=eg:Filter(c76372772.mfilter,nil,tp,c,re)
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			tc:CancelToGrave()
			sg:Merge(tc:GetOverlayGroup())
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
	Duel.RegisterFlagEffect(tp,76372772,RESET_CHAIN,0,1)
end

function c76372772.rifilter(c)
	return c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c76372772.ricost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c76372772.ritg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local og=g:Filter(c76372772.rifilter,nil) 
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return og:GetCount()>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=og:Select(tp,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c76372772.riop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end


function c76372772.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c76372772.filter(c)
	return c:IsSetCard(0x3a) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c76372772.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76372772.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76372772.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76372772.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c76372772.filter2(c)
	return c:IsSetCard(0x3a) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c76372772.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76372772.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76372772.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76372772.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
