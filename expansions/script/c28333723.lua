--沉醉的古之谣 纯白梦想曲
function c28333723.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c28333723.cost)
	c:RegisterEffect(e0)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28333723,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c28333723.efcon)
	e1:SetTarget(c28333723.eftg)
	e1:SetOperation(c28333723.efop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_MSET+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c28333723.settg)
	e2:SetOperation(c28333723.setop)
	c:RegisterEffect(e2)
	if not c28333723.global_check then
		c28333723.global_check=true
		c28333723.effect_list={}
	end
end
function c28333723.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_DARK):FilterCount(Card.IsFaceup,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeckAsCost(tp,ct) end
	Duel.DiscardDeck(tp,ct,REASON_COST)
end
function c28333723.chkfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)-- and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousLevelOnField()==3
end
function c28333723.efcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28333723.chkfilter,1,nil,tp)
end
function c28333723.efilter(e)
	local ct=#c28333723.effect_list
	if e:IsHasRange(LOCATION_ONFIELD) and e:IsActivated() then c28333723.effect_list[ct+1]=e end
	return e:IsHasRange(LOCATION_ONFIELD) and e:IsActivated()
end
function c28333723.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER)) then return false end
	c28333723.effect_list={}
	c:IsOriginalEffectProperty(c28333723.efilter)
	for _,te in ipairs(c28333723.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	return false
end
function c28333723.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28333723.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
end
function c28333723.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c28333723.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	c28333723.effect_list={}
	tc:IsOriginalEffectProperty(c28333723.efilter)
	local e_list={}
	for _,te in ipairs(c28333723.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28333723.effect_list,i) end
	end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c28333723.effect_list={}
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)--Original Property
end
function c28333723.setfilter(c,e,tp,chk)
	return c:IsSetCard(0x285) and (c:IsSSetable() or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c28333723.gcheck(g,tp)
	local mt=Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return g:GetClassCount(Card.GetLocation)==2 and g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=mt and g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1 and g:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=st
end
function c28333723.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28333723.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,0)
	if chk==0 then return g:CheckSubGroup(c28333723.gcheck,2,2) end
end
function c28333723.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28333723.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,c28333723.gcheck,false,2,2,tp)
	if not sg then return end
	local mg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if #mg>0 then
		sg:Sub(mg)
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
	Duel.SSet(tp,sg,tp,false)
	sg:Merge(mg)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.Destroy(tc,REASON_EFFECT)
end
