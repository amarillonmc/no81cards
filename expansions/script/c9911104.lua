--荣枯之蒙昧灵 伊甸撒哈拉
function c9911104.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911104,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c9911104.otcon)
	e1:SetOperation(c9911104.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--summon with 2 tribute
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9911104,3))
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SUMMON_PROC)
	e8:SetCondition(c9911104.ttcon)
	e8:SetOperation(c9911104.ttop)
	e8:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e8)
	--flag
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c9911104.valcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c9911104.flagcon)
	e4:SetOperation(c9911104.flagop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c9911104.drcon)
	e5:SetTarget(c9911104.drtg)
	e5:SetOperation(c9911104.drop)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c9911104.descon)
	e6:SetTarget(c9911104.destg)
	e6:SetOperation(c9911104.desop)
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)
end
function c9911104.flag()
	local g1=Duel.GetMatchingGroup(c9911104.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(c9911104.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_DECK)
	local g3=Duel.GetMatchingGroup(c9911104.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,LOCATION_GRAVE)
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
function c9911104.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9911104.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c9911104.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c9911104.otop(e,tp,eg,ep,ev,re,r,rp,c)
	c9911104.flag()
	local mg=Duel.GetMatchingGroup(c9911104.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c9911104.ttcon(e,c,minc)
	if c==nil then return true end
	return c:IsLevelAbove(7) and minc<=2 and Duel.CheckTribute(c,2)
end
function c9911104.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	c9911104.flag()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c9911104.cfilter(c,loc)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(loc)
end
function c9911104.valcheck(e,c)
	local lab=0
	local g=c:GetMaterial()
	if g:IsExists(c9911104.cfilter,1,nil,LOCATION_HAND) then lab=lab+1 end
	if g:IsExists(c9911104.cfilter,1,nil,LOCATION_GRAVE) then lab=lab+2 end
	e:SetLabel(lab)
end
function c9911104.flagcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c9911104.flagop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabelObject():GetLabel()
	if bit.band(lab,2)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911104,2))
	end
end
function c9911104.drcon(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabelObject():GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and bit.band(lab,1)~=0
end
function c9911104.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c9911104.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c9911104.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c9911104.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c9911104.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local lab=e:GetLabelObject():GetLabel()
	if rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 and bit.band(lab,2)~=0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(tp,aux.Stringid(9911104,1)) then
		Duel.BreakEffect()
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c9911104.repop)
	end
end
function c9911104.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
end
