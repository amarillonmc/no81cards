--混沌武装龙
function c98920709.initial_effect(c)
	c:SetSPSummonOnce(98920709)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920709,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98920709.spcon)
	e1:SetOperation(c98920709.spop0)
	c:RegisterEffect(e1)
	--sp2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920709,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetTarget(c98920709.sptg)
	e2:SetOperation(c98920709.spop)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e1:SetLabelObject(e2)
	--attack down
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(98920709,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c98920709.cost)
	e3:SetOperation(c98920709.operation)
	c:RegisterEffect(e3)
end
function c98920709.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c98920709.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c98920709.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK)
end
function c98920709.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98920709.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	while tc do
		tc:RegisterFlagEffect(98920709,RESET_EVENT+0x1fe0000,0,1)
		tc=og:GetNext()
	end
		e:GetLabelObject():SetLabel(1)
	if c:GetFlagEffect(98920709)==0 then
		  c:RegisterFlagEffect(98920709,RESET_EVENT+0x1fe0000,0,0)
		  e:GetLabelObject():GetLabelObject():Clear()
	end
	e:GetLabelObject():GetLabelObject():Merge(og)
end
function c98920709.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920709.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and rg:GetCount()==2 and rg:IsExists(c98920709.filter,2,nil,e)  end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920709.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if rg:GetCount()==2 then
		local g=rg:FilterSelect(tp,c98920709.filter,1,1,nil,e)   
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		rg:Sub(g)
		local sg=rg:GetFirst()
		Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
function c98920709.afilter(c)
	return c:IsFaceup() and c:IsAttackAbove(0) and c:IsAttackBelow(2800)
end
function c98920709.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100,true)
		and Duel.IsExistingMatchingCard(c98920709.afilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c98920709.afilter,tp,0,LOCATION_MZONE,e:GetHandler())
	local tg,atk=g:GetMinGroup(Card.GetAttack)
	local maxc=math.min(Duel.GetLP(tp),atk,2800)
	local ct=math.floor(maxc/100)
	local t={}
	for i=1,29-ct do
		t[i]=(i+ct-1)*100
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost,true)
	e:SetLabel(cost)
end
function c98920709.rmfilter(c,val)
	return c:IsAttackBelow(val) and c:IsAbleToRemove() and c:IsFaceup()
end
function c98920709.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabel()
	local g=Duel.GetMatchingGroup(c98920709.rmfilter,tp,0,LOCATION_MZONE,nil,val)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
end