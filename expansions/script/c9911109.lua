--沉浮之蒙昧灵 莎湖兰
function c9911109.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911109,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c9911109.otcon)
	e1:SetOperation(c9911109.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--summon with 2 tribute
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9911109,3))
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SUMMON_PROC)
	e8:SetCondition(c9911109.ttcon)
	e8:SetOperation(c9911109.ttop)
	e8:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e8)
	--flag
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c9911109.valcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c9911109.flagcon)
	e4:SetOperation(c9911109.flagop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c9911109.thcon)
	e5:SetTarget(c9911109.thtg)
	e5:SetOperation(c9911109.thop)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	--limit
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c9911109.limcon)
	e6:SetOperation(c9911109.limop)
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)
end
function c9911109.flag()
	local g1=Duel.GetMatchingGroup(c9911109.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(c9911109.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_DECK)
	local g3=Duel.GetMatchingGroup(c9911109.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_GRAVE)
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
function c9911109.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9911109.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c9911109.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c9911109.otop(e,tp,eg,ep,ev,re,r,rp,c)
	c9911109.flag()
	local mg=Duel.GetMatchingGroup(c9911109.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c9911109.ttcon(e,c,minc)
	if c==nil then return true end
	return c:IsLevelAbove(7) and minc<=2 and Duel.CheckTribute(c,2)
end
function c9911109.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	c9911109.flag()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c9911109.cfilter(c,loc)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(loc)
end
function c9911109.valcheck(e,c)
	local lab=0
	local g=c:GetMaterial()
	if g:IsExists(c9911109.cfilter,1,nil,LOCATION_GRAVE) then lab=lab+1 end
	if g:IsExists(c9911109.cfilter,1,nil,LOCATION_DECK) then lab=lab+2 end
	e:SetLabel(lab)
end
function c9911109.flagcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c9911109.flagop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabelObject():GetLabel()
	if bit.band(lab,2)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911109,2))
	end
end
function c9911109.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabelObject():GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and bit.band(lab,1)~=0
end
function c9911109.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9911109.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9911109.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c9911109.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function c9911109.limop(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(1)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_CHAIN)
	e2:SetTargetRange(0,1)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsExistingMatchingCard(c9911109.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and bit.band(lab,2)~=0 and Duel.SelectYesNo(tp,aux.Stringid(9911109,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9911109.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
