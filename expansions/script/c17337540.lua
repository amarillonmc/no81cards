--罗兹瓦尔
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337400)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1101)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+2)
	e3:SetCondition(s.descon)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.costfilter1(c)
	return c:IsReleasable() and c:IsSetCard(0x5f50)
end
function s.costfilter2(c)
	return c:IsReleasable() and c:IsSetCard(0x3f50)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.costfilter1,tp,LOCATION_MZONE,0,nil)
	local rg=Duel.GetMatchingGroup(s.costfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(rg)
	if chk==0 then return #mg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,s.selectcheck,false,1,2,tp)
	Duel.Release(sg,REASON_COST)
end
function s.selectcheck(mg,tp)
	return Duel.GetMZoneCount(tp,mg)>0 and (#mg==1 and mg:IsExists(Card.IsSetCard,1,nil,0x5f50) or #mg==2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:IsCostChecked() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and 
	Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function s.rmfilter(c)
	return c:IsSetCard(0x3f50) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.refilter(c)
	return c:IsSetCard(0x3f50) and c:IsAbleToHand()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_DECK,0,nil)
	local ct=0
	if cg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then ct=ct+1 end
	if cg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then ct=ct+1 end
	if cg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then ct=ct+1 end
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.typecheck(g)
		local typ=0
	for tc in aux.Next(g) do
		if typ&bit.band(tc:GetType(),0x7)==0 then
			typ=typ|bit.band(tc:GetType(),0x7)
		else
			return false
		end
	end
	return true
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_DECK,0,nil)
	if not g:CheckSubGroup(s.typecheck,ct,ct) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,s.typecheck,false,ct,ct)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x3f50)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,e:GetHandler(),tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x5f50) or aux.IsCodeListed(c,17337400) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0x5f50) or aux.IsCodeListed(c,17337400) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER) end,
		tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if Duel.Destroy(g,REASON_EFFECT)==0 then
			Duel.BreakEffect()
			local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
			Duel.Destroy(dg,REASON_EFFECT)
	   	end
	else
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end