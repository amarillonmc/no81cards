--假面骑士 空我/升华天马
local m=40020160
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40020183)
	--change name
	aux.EnableChangeCode(c,40020183,LOCATION_MZONE)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.descon)
	c:RegisterEffect(e2)
	--negate spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m+1)
	e5:SetCondition(cm.negcon)
	e5:SetTarget(cm.negtg)
	e5:SetOperation(cm.negop)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetReasonEffect() and tc:GetReasonEffect():IsHasType(EFFECT_TYPE_ACTIONS) and aux.IsCodeListed(tc:GetReasonEffect():GetHandler(),40020183) then
			tc:RegisterFlagEffect(40020183,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
		end
		tc=eg:GetNext()
	end
end

function cm.fselect(g,tp,sc)
	local atk=0
	local matk=0
	local tc=g:GetFirst()
	while tc do
		matk=matk+tc:GetAttack()
		if matk>=2600 and g:GetNext()~=nil then return false end 
		tc=g:GetNext()
	end
	return matk>=2600 
end
function cm.costfilter(c,tp)
	return aux.IsCodeListed(c,40020183) and c:IsAbleToRemoveAsCost()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.desfilter(c) 
	return c:IsType(TYPE_MONSTER) and not c:IsAttack(0) and c:IsFaceup()
end
function cm.thfilter(c,e,tp,ec) 
	return c:IsCode(40020183) and c:IsLevelAbove(5) and c:IsAbleToHand() and ec:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.desfilter(chkc) end
	local mg=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then
		local mgck=0
		local tc=mg:GetFirst()
		local atk=0
		while tc do
			atk=atk+tc:GetAttack()
			if atk>=2600 then 
				mgck=1
				break
			end 
			tc=mg:GetNext()
		end
	return mgck==1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=mg:SelectSubGroup(tp,cm.fselect,false,1,99,tp,c)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.Destroy(tg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
		Duel.BreakEffect()
		local op=0
		if (ft>0 or c:GetSequence()<5) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		end
		if op==0 then Duel.SendtoGrave(c,REASON_DISCARD) end
		if op==1 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)	
			local thc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,c):GetFirst()
			if thc and Duel.SendtoHand(thc,nil,REASON_EFFECT)~=0 then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end   
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or e:GetHandler():GetFlagEffect(40020183)==0 then return false end
	return ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
