--哈迪斯之灾
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.rscost)
	e1:SetTarget(s.rstg)
	e1:SetOperation(s.rsop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.pztarget)
	e2:SetOperation(s.pzoperation)
	c:RegisterEffect(e2)
end


function s.hades_filter(c)
	return c:IsCode(40020547) and c:IsFaceup()
end


function s.condition(e, tp, eg, ep, ev, re, r, rp)

	return Duel.IsExistingMatchingCard(s.hades_filter, tp, LOCATION_ONFIELD + LOCATION_EXTRA, 0, 1, nil)
end

function s.rtfilter(c)
	return c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function s.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
			and c:IsAbleToRemoveAsCost()
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end


function s.pzfilter(c)
	return c:IsCode(40020547) and not c:IsForbidden()
end

function s.pztarget(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.pzfilter(chkc) end
	if chk == 0 then 
		return Duel.IsExistingTarget(s.pzfilter, tp, LOCATION_GRAVE, 0, 1, nil)
			and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) 
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectTarget(tp, s.pzfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.pzoperation(e, tp, eg, ep, ev, re, r, rp)
	if not (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then return end
	
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true) then
			Duel.Draw(tp, 1, REASON_EFFECT)
		end
	end
end
