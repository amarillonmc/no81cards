--神岚火
--script by 原初灵心
function c130006000.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(130006000,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(LOCATION_HAND)
	e1:SetCost(c130006000.cost)
	e1:SetTarget(c130006000.target)
	e1:SetOperation(c130006000.operation)
	c:RegisterEffect(e1)
	--
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(130006000,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(130006000,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCondition(c130006000.con)
	e3:SetTarget(c130006000.tg)
	e3:SetOperation(c130006000.op)
	c:RegisterEffect(e3)
end
function c130006000.filter(c,g)
	return c:GetSequence()==(#g-1)
end
function c130006000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lab=e:GetLabel()
	if chk==0 then 
		if lab==LOCATION_HAND then return e:GetHandler():IsDiscardable() 
		elseif lab==LOCATION_GRAVE then 
			local rg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
			rg:RemoveCard(e:GetHandler())
			return e:GetHandler():IsAbleToRemoveAsCost() and #rg>0
		else return false end
	end
	if lab==LOCATION_HAND then Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD) 
	elseif lab==LOCATION_GRAVE then Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	end	
end
function c130006000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lab=e:GetLabel()
	local loc,category=0,0
	local achek=false
	if lab==LOCATION_HAND then 
		loc=LOCATION_EXTRA
		category=CATEGORY_DESTROY
		achek=true
	elseif lab==LOCATION_GRAVE then 
		loc=LOCATION_GRAVE 
		category=CATEGORY_REMOVE
		achek=true
	end
	if chk==0 then return achek and Duel.GetFieldGroupCount(tp,loc,loc)>0 
	end
	local ct=Duel.GetFieldGroupCount(tp,loc,loc)
	Duel.SetOperationInfo(0,category,nil,math.min(1,ct),0,loc)
end
function c130006000.operation(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabel()
	local loc=0
	if lab==LOCATION_HAND then 
		loc=LOCATION_EXTRA
	elseif lab==LOCATION_GRAVE then 
		loc=LOCATION_GRAVE 
	else return end
	local g1=Duel.GetFieldGroup(tp,loc,0)
	local g2=Duel.GetFieldGroup(tp,0,loc)
	if g1:GetCount()<=0 and g2:GetCount()<=0 then return end
	local sg=g1:Filter(c130006000.filter,nil,g1)
	local sg2=g2:Filter(c130006000.filter,nil,g2)
	sg:Merge(sg2)
	if lab==LOCATION_HAND then 
		Duel.Destroy(sg,REASON_EFFECT)
	elseif lab==LOCATION_GRAVE then 
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c130006000.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>=30
end
function c130006000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsFaceup() 
		and c:GetFlagEffect(130006000)==0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	c:RegisterFlagEffect(130006000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function c130006000.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	rg:RemoveCard(c)
	if fct<=0 then return end
	if c:IsRelateToEffect(e) then 
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
			if #rg>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
			Duel.Damage(1-tp,3000,REASON_EFFECT)
			end
		end
	end
end
