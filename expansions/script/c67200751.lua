--噩梦回廊的守护者
function c67200751.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200751,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,67200751)
	e2:SetCondition(c67200751.spcon)
	e2:SetTarget(c67200751.sptg)
	e2:SetOperation(c67200751.spop)
	c:RegisterEffect(e2)  
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200751,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,67200751)
	e3:SetCondition(c67200751.cecondition)
	e3:SetTarget(c67200751.cetarget)
	e3:SetOperation(c67200751.ceoperation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c67200751.cecon2)
	c:RegisterEffect(e4)  
end
function c67200751.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c67200751.psfilter(c)
	return c:IsCode(67200755) and not c:IsForbidden()
end
function c67200751.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200751.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c67200751.psfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(67200751,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200751.psfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			end
		end
	end
end
--
function c67200751.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c67200751.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c67200751.cfilter(c)
	return c:IsFaceup() and c:IsCode(67200755)
end
function c67200751.cecondition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 and Duel.IsExistingMatchingCard(c67200751.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c67200751.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c67200751.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200751.thfilter,rp,0,LOCATION_ONFIELD,1,nil) end
end
function c67200751.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c67200751.repop)
end
--
function c67200751.cecon2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 and Duel.IsExistingMatchingCard(c67200751.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,67200755)
end