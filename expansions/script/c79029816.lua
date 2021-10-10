--逆元构造 极昼
function c79029816.initial_effect(c)
	c:SetSPSummonOnce(79029816)
	--xyz summon
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_VALUE_SELF)
	e2:SetCondition(c79029816.sprcon)
	e2:SetOperation(c79029816.sprop)
	c:RegisterEffect(e2)
	--xx 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c79029816.xxtg)
	e3:SetOperation(c79029816.xxop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c79029816.desreptg)
	e4:SetValue(c79029816.desrepval)
	e4:SetOperation(c79029816.desrepop)
	c:RegisterEffect(e4)
end
function c79029816.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa991) and c:IsCanOverlay()
end
function c79029816.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return g:IsExists(c79029816.sprfilter2,1,c,tp,c,sc,lv)
end
function c79029816.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c79029816.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029816.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c79029816.sprfilter1,1,nil,tp,g,c)
end
function c79029816.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029816.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc1=g:FilterSelect(tp,c79029816.sprfilter1,1,1,nil,tp,g,c):GetFirst()
		local og=tc1:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc2=g:FilterSelect(tp,c79029816.sprfilter2,1,1,tc1,tp,tc1,c,tc1:GetLevel()):GetFirst()
		local og=tc2:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	local g1=Group.FromCards(tc1,tc2)
	Duel.Overlay(e:GetHandler(),g1)
end
function c79029816.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	local b1=mg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
	local b2=mg:IsExists(Card.IsType,1,nil,TYPE_FUSION) 
	local b3=mg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b4=mg:IsExists(Card.IsType,1,nil,TYPE_LINK) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return (b1 or b2 or b3 or b4) and c:IsSummonType(SUMMON_VALUE_SELF) end
	if b2 then 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0) 
	end
	if b3 then 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
	end 
	if b4 then 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c79029816.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	local b1=mg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
	local b2=mg:IsExists(Card.IsType,1,nil,TYPE_FUSION) 
	local b3=mg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b4=mg:IsExists(Card.IsType,1,nil,TYPE_LINK) and Duel.IsPlayerCanDraw(tp,1)
	if b1 then 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c:GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end
	if b2 then 
	Duel.Recover(tp,c:GetAttack(),REASON_EFFECT)
	end
	if b3 then 
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
	if b4 then 
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c79029816.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79029816.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79029816.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c79029816.desrepval(e,c)
	return c79029816.repfilter(c,e:GetHandlerPlayer())
end
function c79029816.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetHandler():GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local rg=g:Select(tp,2,2,nil)
	Duel.SendtoGrave(rg,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,79029816)
	local tc1=rg:GetFirst()
	local tc2=rg:GetNext()
	local flag1=0
	if tc1:IsType(TYPE_FUSION) then flag1=bit.bor(flag1,TYPE_FUSION) end
	if tc1:IsType(TYPE_SYNCHRO) then flag1=bit.bor(flag1,TYPE_SYNCHRO) end
	if tc1:IsType(TYPE_XYZ) then flag1=bit.bor(flag1,TYPE_XYZ) end
	if tc1:IsType(TYPE_LINK) then flag1=bit.bor(flag1,TYPE_LINK) end
	local flag2=0
	if tc2:IsType(TYPE_FUSION) then flag2=bit.bor(flag2,TYPE_FUSION) end
	if tc2:IsType(TYPE_SYNCHRO) then flag2=bit.bor(flag2,TYPE_SYNCHRO) end
	if tc2:IsType(TYPE_XYZ) then flag2=bit.bor(flag2,TYPE_XYZ) end
	if tc2:IsType(TYPE_LINK) then flag2=bit.bor(flag2,TYPE_LINK) end 
	if flag1==0 or flag2==0 then return end
	if bit.band(flag1,flag2)~=0 then 
	Duel.Recover(tp,2000,REASON_EFFECT)
	end
	if bit.band(flag1,flag2)==0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) then 
	local ng=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local mc=ng:GetFirst()
	while mc do
		Duel.NegateRelatedChain(mc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		mc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		mc:RegisterEffect(e2)
		if mc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e3)
		end
		mc=g:GetNext()
	end
	end 
end



