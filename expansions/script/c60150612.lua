--千夜 极光霸刀
function c60150612.initial_effect(c)
	c:SetUniqueOnField(1,0,60150612)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150612.ffilter,aux.FilterBoolFunction(c60150612.ffilter2),false)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c60150612.splimit)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c60150612.sprcon)
	e3:SetOperation(c60150612.sprop)
	c:RegisterEffect(e3)
	--atk immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c60150612.efilter2)
	c:RegisterEffect(e6)
	--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c60150612.efilter3)
	c:RegisterEffect(e7)
	--destroy
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TODECK)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_BATTLE_START)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetTarget(c60150612.destg)
	e10:SetOperation(c60150612.desop)
	c:RegisterEffect(e10)
end
function c60150612.ffilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) 
end
function c60150612.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsHasEffect(60150618)
end
function c60150612.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150612.spfilter1(c,tp,fc)
	return c:IsSetCard(0x3b21) and c:IsCanBeFusionMaterial(fc,true) and c:IsFaceup() 
		and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c60150612.spfilter2,tp,LOCATION_MZONE,0,1,c,fc) 
end
function c60150612.spfilter2(c,fc)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsHasEffect(60150618)) and c:IsCanBeFusionMaterial(fc)
		and c:IsAbleToDeckOrExtraAsCost() 
end
function c60150612.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x3b21) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c60150612.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c60150612.filter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c60150612.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60150612.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	end
end
function c60150612.gfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150612.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c60150612.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c60150612.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	c:SetMaterial(g1)
	local g=g1:Filter(c60150612.gfilter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150602,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150602,1))
		local sg=g:Select(tp,1,g:GetCount(),nil)
		local gtc=sg:GetFirst()
		while gtc do
			g1:RemoveCard(gtc)
			gtc=sg:GetNext()
		end
		Duel.SendtoExtraP(sg,nil,REASON_COST+REASON_MATERIAL+REASON_FUSION)
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c60150612.efilter2(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() then
		local atk=e:GetHandler():GetBaseAttack()
		local ec=te:GetHandler()
		return ec:GetBaseAttack()<atk
	end
	return false
end
function c60150612.efilter3(e,c)
	return c:GetAttack()>e:GetHandler():GetAttack()
end
function c60150612.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:GetAttack()==c:GetAttack() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function c60150612.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() and tc:GetAttack()==c:GetAttack() then
		local atk=tc:GetAttack()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end