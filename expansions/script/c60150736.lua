--终末的少女 纯白型法尔萨莉娅
function c60150736.initial_effect(c)
	c:SetUniqueOnField(1,0,60150736)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,60150726,60150798,true,true)
	--cannot fusion material
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60150736.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60150736.spcon)
	e2:SetOperation(c60150736.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c60150736.decost)
	e3:SetTarget(c60150736.destg)
	e3:SetOperation(c60150736.desop)
	c:RegisterEffect(e3)
end
function c60150736.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150736.spfilter1(c,tp,fc)
	return c:IsCode(60150726) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c60150736.spfilter2,tp,LOCATION_ONFIELD,0,1,c,fc)
end
function c60150736.spfilter2(c,fc)
	return c:IsCode(60150798) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
end
function c60150736.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if (c1 and c1:IsCode(60150798)) or (c2 and c2:IsCode(60150798)) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c60150736.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60150736.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
	end
end
function c60150736.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150736,0))
		local g1=Duel.SelectMatchingCard(tp,c60150736.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150736,1))
		local g2=Duel.SelectMatchingCard(tp,c60150736.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150736,0))
		local g1=Duel.SelectMatchingCard(tp,c60150736.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150736,1))
		local g2=Duel.SelectMatchingCard(tp,c60150736.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	end
end
function c60150736.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5b22) and not c:IsType(TYPE_FUSION+TYPE_XYZ)
end
function c60150736.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5b22) and c:IsReleasable()
end
function c60150736.cfilter3(c)
	return not c:IsPublic()
end
function c60150736.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if not Duel.IsExistingMatchingCard(c60150736.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_DECK,0,1,nil) 
			or Duel.CheckReleaseGroupEx(tp,nil,1,e:GetHandler()) end
		local g=Duel.GetMatchingGroup(c60150736.cfilter2,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(c60150736.cfilter3,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150736,2)) then
			Duel.ConfirmCards(1-tp,g2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local sg=g:Select(tp,1,1,e:GetHandler())
			Duel.SendtoGrave(sg,REASON_RELEASE+REASON_COST)
			Duel.ShuffleHand(tp)
		else
			local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,e:GetHandler())
			Duel.Release(g,REASON_COST)
		end
	else
		if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,e:GetHandler()) end
		local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,e:GetHandler())
		Duel.Release(g,REASON_COST)
	end
end
function c60150736.filter(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk) and c:IsReleasableByEffect() and c:IsAbleToRemove()
end
function c60150736.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c60150736.filter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c60150736.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function c60150736.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150736,3))
	local g=Duel.GetMatchingGroup(c60150736.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	local ct=Duel.Release(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end
