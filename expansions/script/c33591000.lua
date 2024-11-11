local m=33591000
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),6,2,cm.ovfilter2,aux.Stringid(m,0))
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,m)
	e2:SetCondition(cm.necon)
	e2:SetCost(cm.necost)
	e2:SetTarget(cm.netg)
	e2:SetOperation(cm.neop)
	c:RegisterEffect(e2)
	--atk/def gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.value)
	c:RegisterEffect(e2)
end
function StarFlow(x,y)
	local t=0
	if x==nil then x=0 end
	if y==nil then y=0 end
	if x>=y then
	    t=x
	else
	    t=y
	end
	if t==0 then return 0 end
	local sf=((x-y)/t)
    local formatted_num = string.format("%.2f",sf)
    local num = tonumber(formatted_num)*100
    return num
end
function cm.ovfilter2(c)
    local tp=c:GetControler()
	local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
	return c:IsFaceup() and c:GetAttack()>=(2500) and sf<=25
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetAttack()>=(2500)  and c:IsCanBeXyzMaterial(c)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    local c=e:GetHandler()
    local tp=c:GetControler()
	local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
    return Duel.GetTurnPlayer()~=tp and sf<=25 and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<0 or not Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,cm.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(c,mg)
		end
		c:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(c,Group.FromCards(tc))
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
    local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,e:GetHandler())
    if #g<1 then return end
    local oatk=re:GetHandler():GetAttack()
    local satk=g:GetSum(Card.GetAttack)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and satk>=oatk and sf<=50
end
function cm.costfilter(c,satk,oatk2)
    local oatk=c:GetAttack()
    return c:IsReleasable()
end
function cm.necost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,e:GetHandler())
    if #g<1 then return end
    local oatk=re:GetHandler():GetAttack()
    if oatk<=0 then
        if chk==0 then return true end
        local g3=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)
        Duel.Release(g3,REASON_COST)
    else
        local satk=g:GetSum(Card.GetAttack)
	    if chk==0 then return satk>=oatk end
	    local g2=g:SelectWithSumGreater(tp,Card.GetAttack,oatk)
	    Duel.Release(g2,REASON_COST)
	end
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	    Duel.BreakEffect()
	    c:RemoveOverlayCard(tp,1,1,REASON_COST)
	    Duel.Destroy(rc,REASON_EFFECT)
    end
end
function cm.value(e,c)
    local sc=e:GetHandler()
    local tp=sc:GetControler()
    local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
	return sf*10
end