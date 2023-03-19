--幻灯的翠玉碑使
function c67200793.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200793,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200793)
	e1:SetCondition(c67200793.chcon)
	e1:SetTarget(c67200793.chtg)
	e1:SetOperation(c67200793.chop)
	c:RegisterEffect(e1)
	--spsummon and to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200793,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200794)
	e2:SetCondition(c67200793.descon)
	e2:SetTarget(c67200793.destg)
	e2:SetOperation(c67200793.desop)
	c:RegisterEffect(e2) 
end
--
function c67200793.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c67200793.chcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res then
		return tep~=tp and tre:GetActivateLocation()==LOCATION_HAND and tre:IsActiveType(TYPE_MONSTER)
	end
end
function c67200793.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(67200793)
end
function c67200793.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c67200793.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c67200793.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c67200793.repop)
end
function c67200793.rfilter(c,tp)
	--local tp=c:GetControler()
	return c:IsFaceup() and c:IsReleasable() 
end

function c67200793.mfilter(c,tp)
	--local tp=c:GetControler()
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) 
end
function c67200793.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()>0 then
		if Duel.ConfirmCards(tp,g1)~=0 and Duel.IsExistingMatchingCard(c67200793.spfilter,tp,0,LOCATION_HAND,1,nil,e,tp) then
			Duel.BreakEffect()
			local rg=Duel.GetMatchingGroup(c67200793.rfilter,tp,0,LOCATION_ONFIELD,nil,tp)
			local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
			local g=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				g=rg:Select(tp,1,1,nil)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				g=rg:FilterSelect(tp,c67200793.mfilter,1,1,nil,tp)
				local g2=rg:Select(tp,1,1,g:GetFirst())
				g:Merge(g2)
			end
			if Duel.Release(g,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local ggg=Duel.SelectMatchingCard(tp,c67200793.spfilter,tp,0,LOCATION_HAND,1,1,nil,e,tp)
				if ggg:GetCount()>0 then
					Duel.SpecialSummon(ggg,0,1-tp,1-tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
--
function c67200793.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and not eg:IsContains(e:GetHandler())
end
function c67200793.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67200793.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end