--践行正义 究极骑士公爵兽
function c16349005.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c16349005.ffilter,3,true)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349005,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c16349005.target)
	e1:SetOperation(c16349005.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16349005,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16349005)
	e2:SetTarget(c16349005.destg)
	e2:SetOperation(c16349005.desop)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16349005,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16349005+1)
	e3:SetTarget(c16349005.tgtg)
	e3:SetOperation(c16349005.tgop)
	c:RegisterEffect(e3)
end
function c16349005.ffilter(c,fc,sub,mg,sg)
	return c:IsLevelAbove(7) and (not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsLevel,1,c,c:GetLevel())
			and not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())))
end
function c16349005.pfilter(c,tp)
	return c:IsCode(16349053) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16349005.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16349005.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16349005.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16349005.desfilter(c,tp)
	return c:IsFaceup() and c:IsAttackBelow(2000)
end
function c16349005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg1=Duel.GetMatchingGroup(c16349005.desfilter,tp,0,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	if chk==0 then return #sg1>0 or (ct>=10 and #sg2>0) end
	if ct>=10 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg2,sg2:GetCount(),0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg1,sg1:GetCount(),0,0)
	end
end
function c16349005.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.GetMatchingGroup(c16349005.desfilter,tp,0,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	if ct>=10 then
		Duel.Destroy(sg2,0x40)
	else
		Duel.Destroy(sg1,0x40)
	end
end
function c16349005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3dc2)
end
function c16349005.tgfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c16349005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c16349005.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(c16349005.tgfilter,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c16349005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c16349005.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c16349005.tgfilter,tp,0,LOCATION_EXTRA,nil)
	if ct>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,ct,nil)
		if #sg>0 then Duel.SendtoGrave(sg,0x40) end
	end
end