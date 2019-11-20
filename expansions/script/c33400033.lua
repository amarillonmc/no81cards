--D.A.L-时崎狂三
function c33400033.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c33400033.fusfilter1,c33400033.fusfilter2,c33400033.fusfilter3,c33400033.fusfilter4,c33400033.fusfilter5)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c33400033.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(1)
	e1:SetCondition(c33400033.spcon)
	e1:SetOperation(c33400033.spop)
	c:RegisterEffect(e1)
	  --activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(c33400033.afilter))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	 --ChainLimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c33400033.tgop)
	c:RegisterEffect(e3)
	--Equip Okatana
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c33400033.Eqop1)
	c:RegisterEffect(e4)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(33400033,0))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(2,33400033)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c33400033.cost)
	e6:SetCondition(c33400033.discon)
	e6:SetTarget(c33400033.distg)
	e6:SetOperation(c33400033.disop)
	c:RegisterEffect(e6)
end
function c33400033.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c33400033.fusfilter1(c)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_FUSION)
end
function c33400033.fusfilter2(c)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_SYNCHRO)
end
function c33400033.fusfilter3(c)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_XYZ)
end
function c33400033.fusfilter4(c)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_LINK)
end
function c33400033.fusfilter5(c)
	return c:IsSetCard(0x3341) 
end
function c33400033.spfilter1(c,fc,tp)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_FUSION) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() 
end
function c33400033.spfilter2(c,fc,tp)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_SYNCHRO) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() 
end
function c33400033.spfilter3(c,fc,tp)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_XYZ) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() 
end
function c33400033.spfilter4(c,fc,tp)
	return c:IsSetCard(0x3341) and c:IsFusionType(TYPE_LINK) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() 
end
function c33400033.spfilter5(c,fc,tp)
	return c:IsSetCard(0x3341) and c:IsLevelBelow(4) and c:IsType(TYPE_EFFECT) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() 
end
function c33400033.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c33400033.spfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,c,fc,tp) 
		and Duel.IsExistingMatchingCard(c33400033.spfilter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,c,fc,tp)
		and Duel.IsExistingMatchingCard(c33400033.spfilter3,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,c,fc,tp)
		and Duel.IsExistingMatchingCard(c33400033.spfilter4,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,c,fc,tp)
		and Duel.IsExistingMatchingCard(c33400033.spfilter5,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,c,fc,tp)
end
function c33400033.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400033,1))
	local g1=Duel.SelectMatchingCard(tp,c33400033.spfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400033,2))
	local g2=Duel.SelectMatchingCard(tp,c33400033.spfilter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400033,3))
	local g3=Duel.SelectMatchingCard(tp,c33400033.spfilter3,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400033,4))
	local g4=Duel.SelectMatchingCard(tp,c33400033.spfilter4,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400033,5))
	local g5=Duel.SelectMatchingCard(tp,c33400033.spfilter5,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,c,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	g1:Merge(g5)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
function c33400033.afilter(c)
	return c:IsSetCard(0x3340) and c:IsType(TYPE_QUICKPLAY)
end
function c33400033.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c33400033.actop)
	Duel.RegisterEffect(e1,tp)  
end
function c33400033.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if  re:GetHandler():IsSetCard(0x3341) then
		Duel.SetChainLimit(c33400033.chainlm)
	end
end
function c33400033.chainlm(e,rp,tp)
	return tp==rp
end
function c33400033.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		c33400033.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33400033.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400034)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
			--immune
			local e4=Effect.CreateEffect(ec)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c33400033.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(c33400033.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			--inm
			local e3=Effect.CreateEffect(ec)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_CHAINING)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCountLimit(2,33400034+10000)
			e3:SetOperation(c33400033.op3)
			token:RegisterEffect(e3)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function c33400033.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c33400033.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function c33400033.op3(e,tp,eg,ep,ev,re,r,rp)	  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			Duel.SelectTarget(tp,c33400033.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
			local tc=Duel.GetFirstTarget()
			tc:AddCounter(0x34f,2)
			local e3_1=Effect.CreateEffect(e:GetHandler())
			e3_1:SetType(EFFECT_TYPE_SINGLE)
			e3_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3_1:SetRange(LOCATION_SZONE)
			e3_1:SetCode(EFFECT_IMMUNE_EFFECT)
			e3_1:SetValue(c33400033.efilter3_1)
			e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			e:GetHandler():RegisterEffect(e3_1,true)
end
function c33400033.efilter3_1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c33400033.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x34f,2)
end
--e6
function c33400033.thfilter(c)
	return  (c:IsSetCard(0x3341) or c:IsSetCard(0x3340)) and  c:IsFaceup() and c:IsAbleToDeckOrExtraAsCost()
end
function c33400033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c33400033.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SelectTarget(tp,c33400033.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_COST)
end
function c33400033.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c33400033.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33400033.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	 Duel.SelectTarget(tp,c33400033.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	 local tc=Duel.GetFirstTarget()
	 tc:AddCounter(0x34f,2)
end