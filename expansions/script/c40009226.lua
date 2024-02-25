--银河眼光子幻龙
function c40009226.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009226)
	e1:SetCondition(c40009226.spcon)
	e1:SetOperation(c40009226.spop)
	c:RegisterEffect(e1)   
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009226,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009227)
	e2:SetTarget(c40009226.target)
	e2:SetOperation(c40009226.operation)
	c:RegisterEffect(e2)
	--extra material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009226,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,40009226+10)
	e3:SetCondition(c40009226.linkcon)
	e3:SetOperation(c40009226.linkop)
	e3:SetValue(SUMMON_TYPE_XYZ)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_EXTRA,0)
	e4:SetTarget(c40009226.mattg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c40009226.spcfilter(c)
	return (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsAbleToGraveAsCost()
end
function c40009226.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009226.spcfilter,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(c40009226.spcfilter,tp,LOCATION_DECK,0,1,c)
end
function c40009226.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c40009226.spcfilter,tp,LOCATION_HAND,0,1,1,c)
	local g2=Duel.SelectMatchingCard(tp,c40009226.spcfilter,tp,LOCATION_DECK,0,1,1,c)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c40009226.filter(c)
	return (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsAbleToHand()
end
function c40009226.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009226.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c40009226.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009226.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40009226.matfilter(c,sc)
	return c:IsFaceup() and c:GetCode(93717133) and c:IsCanBeXyzMaterial(sc)
end

function c40009226.matfilter2(c)
	return c:IsCode(93717133)
end
function c40009226.linkcon(e,c,og,min,max)
	if c==nil then return true end
	if min and min>1 then return false end
	if max and max<1 then return false end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	if og and not min and #og>1 then return false end
	local tp=c:GetControler()
	local rmg
	if og then
		rmg=og
	else
		rmg=Duel.GetMatchingGroup(c40009226.matfilter,tp,LOCATION_MZONE,0,c)
	end
	return rmg:IsExists(c40009226.matfilter2,1,nil,nil)
end
function c40009226.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local rmg
	if og then
		rmg=og
	else
		rmg=Duel.GetMatchingGroup(c40009226.matfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local mat=rmg:FilterSelect(tp,c40009226.matfilter2,1,1,nil,nil)
	c:SetMaterial(mat)
	Duel.Overlay(c,mat)
end
function c40009226.mattg(e,c)
	return c:IsCode(39272762) 
end