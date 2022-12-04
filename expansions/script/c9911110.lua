--寒暖之蒙昧灵 劳伦泰德
function c9911110.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911110,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c9911110.otcon)
	e1:SetOperation(c9911110.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--summon with 2 tribute
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9911110,3))
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SUMMON_PROC)
	e8:SetCondition(c9911110.ttcon)
	e8:SetOperation(c9911110.ttop)
	e8:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e8)
	--flag
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c9911110.valcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c9911110.flagcon)
	e4:SetOperation(c9911110.flagop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c9911110.tgcon)
	e5:SetTarget(c9911110.tgtg)
	e5:SetOperation(c9911110.tgop)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	--disable summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SUMMON)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c9911110.dscon)
	e6:SetCost(c9911110.dscost)
	e6:SetTarget(c9911110.dstg)
	e6:SetOperation(c9911110.dsop)
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
end
function c9911110.flag()
	local g1=Duel.GetMatchingGroup(c9911110.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(c9911110.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_DECK)
	local g3=Duel.GetMatchingGroup(c9911110.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_GRAVE)
	for hc in aux.Next(g1) do
		hc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911104,5))
	end
	for dc in aux.Next(g2) do
		dc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911104,6))
	end
	for gc in aux.Next(g3) do
		gc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911104,7))
	end
end
function c9911110.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9911110.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c9911110.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c9911110.otop(e,tp,eg,ep,ev,re,r,rp,c)
	c9911110.flag()
	local mg=Duel.GetMatchingGroup(c9911110.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c9911110.ttcon(e,c,minc)
	if c==nil then return true end
	return c:IsLevelAbove(7) and minc<=2 and Duel.CheckTribute(c,2)
end
function c9911110.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	c9911110.flag()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c9911110.cfilter(c,loc)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(loc)
end
function c9911110.valcheck(e,c)
	local lab=0
	local g=c:GetMaterial()
	if g:IsExists(c9911110.cfilter,1,nil,LOCATION_DECK) then lab=lab+1 end
	if g:IsExists(c9911110.cfilter,1,nil,LOCATION_HAND) then lab=lab+2 end
	e:SetLabel(lab)
end
function c9911110.flagcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c9911110.flagop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabelObject():GetLabel()
	if bit.band(lab,2)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911110,2))
	end
end
function c9911110.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabelObject():GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and bit.band(lab,1)~=0
end
function c9911110.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c9911110.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9911110.dscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and tp~=ep and Duel.GetCurrentChain()==0
end
function c9911110.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9911110.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c9911110.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c9911110.dsop(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabelObject():GetLabel()
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9911110.rmfilter,tp,0,LOCATION_EXTRA,3,nil)
		and bit.band(lab,2)~=0 and Duel.SelectYesNo(tp,aux.Stringid(9911110,1)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c9911110.rmfilter,tp,0,LOCATION_EXTRA,nil):RandomSelect(tp,3)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
