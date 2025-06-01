--假面骑士 空我/究极形态
local m=40020170
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40020183)
	--change name
	aux.EnableChangeCode(c,40020183,LOCATION_MZONE)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,m+1)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.descon)
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
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function cm.costfilter(c,tp)
	return aux.IsCodeListed(c,40020183) and c:IsAbleToRemoveAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function cm.thfilter(c,e,tp,ec) 
	return c:IsCode(40020183) and c:IsLevelAbove(7) and c:IsAbleToHand() and ec:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	if  c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
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
	local c=e:GetHandler()
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		if e:GetHandler():GetFlagEffect(40020183)==0 then 
			Duel.BreakEffect()
			Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
		end
	end
end
