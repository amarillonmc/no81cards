local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,id-4)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.thfilter(c,ty)
	if not c:IsAbleToHand() then return false end
	local res=false
	if ty&TYPE_MONSTER~=0 and c:IsType(TYPE_TRAP) then res=true end
	if ty&TYPE_SPELL~=0 and c:IsType(TYPE_SPELL) then res=true end
	if ty&TYPE_TRAP~=0 and c:IsType(TYPE_MONSTER) and c:IsAttackAbove(1000) then res=true end
	return res
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ty=c:GetSpecialSummonInfo(SUMMON_INFO_TYPE)&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return ty~=0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,ty) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ty=c:GetSpecialSummonInfo(SUMMON_INFO_TYPE)&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	if ty==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,ty)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_RITUAL) then return false end
	local ty=c:GetSpecialSummonInfo(SUMMON_INFO_TYPE)&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	if ty==0 then return false end
	local oty=re:GetHandler():GetOriginalType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return oty&ty~=0 and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	local rc=re:GetHandler()
	local b1=rc:IsRelateToEffect(re) and rc:IsAbleToRemove()
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.GetDecktopGroup(1-tp,1):GetFirst():IsAbleToRemove()
	if b1 and b2 then
		local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		if op==0 then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		else
			local g=Duel.GetDecktopGroup(1-tp,1)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif b1 then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	elseif b2 then
		local g=Duel.GetDecktopGroup(1-tp,1)
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

