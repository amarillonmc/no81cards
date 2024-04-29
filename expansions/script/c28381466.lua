--青空的羽翼 闪耀色彩
function c28381466.initial_effect(c)
	aux.AddFusionProcFunRep2(c,c28381466.matfilter,4,99,true)
	c:EnableReviveLimit()
   --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c28381466.hspcon)
	e0:SetOperation(c28381466.hspop)
	c:RegisterEffect(e0)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c28381466.valcheck)
	c:RegisterEffect(e1)
	--fusion success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c28381466.regcon)
	e2:SetOperation(c28381466.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c28381466.discon)
	e3:SetCost(c28381466.discost)
	e3:SetTarget(c28381466.distg)
	e3:SetOperation(c28381466.disop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c28381466.atkval)
	c:RegisterEffect(e4)
end
function c28381466.matfilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x283) and c:IsRace(RACE_FAIRY) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) and c:IsCanBeFusionMaterial()
end
function c28381466.hmfilter(c)
	return c:IsFusionSetCard(0x283) and c:IsRace(RACE_FAIRY) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost()
end
function c28381466.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c28381466.hmfilter,c:GetOwner(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return mg:GetClassCount(Card.GetFusionCode,nil)>=4
end
function c28381466.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c28381466.hmfilter,c:GetOwner(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=g:SelectSubGroup(tp,aux.dncheck,false,4,99)
	c:SetMaterial(mg)
	Duel.Remove(mg,POS_FACEUP,REASON_FUSION+REASON_COST+REASON_MATERIAL)
end
function c28381466.valcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetOriginalAttribute())
		tc=g:GetNext()
	end
	e:SetLabel(att)
end
function c28381466.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabelObject():GetLabel()~=0
end
function c28381466.regop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local ct=c:GetMaterial():GetCount()
	if ct>=8 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381466,6))
	end
	if bit.band(att,ATTRIBUTE_LIGHT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if ct>=8 then
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			ge1:SetRange(LOCATION_MZONE)
			ge1:SetTargetRange(LOCATION_MZONE,0)
			ge1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x283))
			ge1:SetValue(aux.tgoval)
			c:RegisterEffect(ge1)
		end
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381466,0))
	end
	if bit.band(att,ATTRIBUTE_DARK)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_REMOVE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,1)
		e2:SetTarget(function(e,c,tp,r)return r==REASON_EFFECT and c==e:GetHandler()end)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		if ct>=8 then
			local ge2=Effect.CreateEffect(c)
			ge2:SetType(EFFECT_TYPE_FIELD)
			ge2:SetCode(EFFECT_CANNOT_REMOVE)
			ge2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			ge2:SetRange(LOCATION_MZONE)
			ge2:SetTargetRange(LOCATION_MZONE,0)
			ge2:SetTarget(c28381466.indtg)
			ge2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(ge2)
		end
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381466,1))
	end
	if bit.band(att,ATTRIBUTE_EARTH)~=0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		if ct>=8 then
			local ge3=Effect.CreateEffect(c)
			ge3:SetType(EFFECT_TYPE_FIELD)
			ge3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			ge3:SetRange(LOCATION_MZONE)
			ge3:SetTargetRange(LOCATION_MZONE,0)
			ge3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x283))
			ge3:SetValue(1)
			c:RegisterEffect(ge3)
		end
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381466,2))
	end
	if bit.band(att,ATTRIBUTE_WATER)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
		if ct>=8 then
			local ge4=Effect.CreateEffect(c)
			ge4:SetType(EFFECT_TYPE_FIELD)
			ge4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			ge4:SetRange(LOCATION_MZONE)
			ge4:SetTargetRange(LOCATION_MZONE,0)
			ge4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x283))
			ge4:SetValue(1)
			c:RegisterEffect(ge4)
		end
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381466,3))
	end
	if bit.band(att,ATTRIBUTE_FIRE)~=0 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_DISABLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e5)
		if ct>=8 then
			local ge5=Effect.CreateEffect(c)
			ge5:SetType(EFFECT_TYPE_FIELD)
			ge5:SetCode(EFFECT_CANNOT_DISABLE)
			ge5:SetRange(LOCATION_MZONE)
			ge5:SetTargetRange(LOCATION_MZONE,0)
			ge5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x283))
			ge5:SetValue(1)
			ge5:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(ge5)
		end
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381466,4))
	end
	if bit.band(att,ATTRIBUTE_WIND)~=0 then
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_IMMUNE_EFFECT)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetValue(c28381466.efilter)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e6)
		if ct>=8 then
			local ge6=Effect.CreateEffect(c)
			ge6:SetType(EFFECT_TYPE_SINGLE)
			ge6:SetCode(EFFECT_IMMUNE_EFFECT)
			ge6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			ge6:SetRange(LOCATION_MZONE)
			ge6:SetValue(c28381466.efilter)
			--effect gain
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e0:SetRange(LOCATION_MZONE)
			e0:SetTargetRange(LOCATION_MZONE,0)
			e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x283))
			e0:SetLabelObject(ge6)
			c:RegisterEffect(e0)
		end
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28381466,5))
	end
end
function c28381466.indtg(e,c,r,tp)
	return c:IsSetCard(0x283) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and r==REASON_EFFECT and c:GetControl()==tp
end
function c28381466.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and te:IsActiveType(TYPE_MONSTER) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c28381466.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and ((re:IsActiveType(TYPE_MONSTER) and Duel.GetFlagEffect(tp,28381466)==0)
		or (re:IsActiveType(TYPE_SPELL) and Duel.GetFlagEffect(tp,38381466)==0)
		or (re:IsActiveType(TYPE_TRAP) and Duel.GetFlagEffect(tp,48381466)==0))
end
function c28381466.disfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c28381466.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28381466.disfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c28381466.disfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil)
	local cg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #cg>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,tp,2,REASON_COST)
end
function c28381466.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:IsActiveType(TYPE_MONSTER) then
		Duel.RegisterFlagEffect(tp,28381466,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:IsActiveType(TYPE_SPELL) then
		Duel.RegisterFlagEffect(tp,38381466,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:IsActiveType(TYPE_TRAP) then
		Duel.RegisterFlagEffect(tp,48381466,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c28381466.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c28381466.atkval(e,c)
	return e:GetHandler():GetMaterial():GetCount()*500
end
