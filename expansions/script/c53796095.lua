local m=53796095
local cm=_G["c"..m]
cm.name="斯芬克斯 安多来"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(cm.rmcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and (e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL) or e:GetHandler():IsSummonType(SUMMON_TYPE_FLIP)) then
		local cp={}
		local func=Card.RegisterEffect
		Card.RegisterEffect=function(tc,e,f)
			if e:GetType()&EFFECT_TYPE_SINGLE~=0 and e:GetType()&(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 and e:GetCode()==EVENT_FLIP_SUMMON_SUCCESS then table.insert(cp,e:Clone()) end
			return func(tc,e,f)
		end
		Duel.CreateToken(tp,tc:GetOriginalCode())
		Card.RegisterEffect=func
		for i,v in ipairs(cp) do
			local e1=v:Clone()
			local pro1,pro2=v:GetProperty()
			e1:SetProperty(pro1&(~EFFECT_FLAG_DELAY),pro2)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetRange(LOCATION_MZONE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetLabelObject(e1)
			e2:SetTargetRange(1,1)
			e2:SetTarget(cm.actarget)
			e2:SetCost(cm.costchk)
			e2:SetOperation(cm.costop)
			tc:RegisterEffect(e2)
		end
	end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costchk(e,te,tp)
	return te:GetHandler():GetFlagEffect(m)<1
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA) and c:IsControler(1-tp)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cfilter,nil,tp)
	local ct1,ct2,ct3=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND),g:FilterCount(Card.IsLocation,nil,LOCATION_DECK),g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,ct1,nil) or ct1<1) and (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,ct2,nil) or ct2<1) and (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,ct3,nil) or ct3<1) end
	e:SetLabel(ct1,ct2,ct3)
	if ct1>0 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct1,tp,LOCATION_HAND) end
	if ct2>0 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct2,tp,LOCATION_DECK) end
	if ct3>0 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct3,tp,LOCATION_EXTRA) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2,ct3=e:GetLabel()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ct1>0 then
		local sg1=g1:RandomSelect(tp,ct1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ct2>0 then
		local sg2=g2:RandomSelect(tp,ct2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and ct3>0 then
		local sg3=g3:RandomSelect(tp,ct3)
		sg:Merge(sg3)
	end
	if #sg>0 then Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) end
end
