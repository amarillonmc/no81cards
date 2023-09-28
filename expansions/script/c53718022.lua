local m=53718022
local cm=_G["c"..m]
cm.name="太清 王诩"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(cm.exop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x353c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local b1=rc:IsOriginalCodeRule(53718001) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=rc:IsOriginalCodeRule(53718002) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	if loc==LOCATION_SZONE and rc:IsFaceup() and (b1 or b2) and e:GetHandler():IsAbleToGrave() and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		local op=re:GetOperation()
		if b1 then
			local repop=function(e,tp,eg,ep,ev,re,r,rp)
				op(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
				if #g1>0 then Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP) end
			end
			re:SetOperation(repop)
		end
		local opx=re:GetOperation()
		if b2 then
			local repop=function(e,tp,eg,ep,ev,re,r,rp)
				opx(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
				if #g2>0 then
					Duel.HintSelection(g2)
					Duel.Destroy(g2,REASON_EFFECT)
				end
			end
			re:SetOperation(repop)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabelObject(re)
		e1:SetOperation(cm.rsop(op))
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.rsop(op)
	return function(e,...)
		local te=e:GetLabelObject()
		if te then te:SetOperation(op) end
		e:Reset()
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsCode(53718001,53718002) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()
	if chk==0 then return b1 or b2 end
	if b1 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(cm.op1)
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	if b2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(cm.op2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
