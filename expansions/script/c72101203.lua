--深空 岩神 洛克
function c72101203.initial_effect(c)
	c:SetUniqueOnField(1,1,72101203)
	--summon rlue
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101203,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c72101203.tzcon)
	e1:SetOperation(c72101203.tzop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c72101203.setcon)
	c:RegisterEffect(e2)
  
	  --wei quankang
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c72101203.qkval)
	c:RegisterEffect(e3)

	--fang zhishiwu
		--1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72101203,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c72101203.fzocon)
	e4:SetTarget(c72101203.fztg)
	e4:SetOperation(c72101203.fzop)
	c:RegisterEffect(e4)
		--2
	local e15=e4:Clone()
	e15:SetType(EFFECT_TYPE_QUICK_O)
	e15:SetCode(EVENT_FREE_CHAIN)
	e15:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e15:SetCondition(c72101203.fzmcon)
	c:RegisterEffect(e15)
		--3
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e5:SetCost(c72101203.fzcost)
	e5:SetCondition(c72101203.fzcon)
	c:RegisterEffect(e5)

	 --cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c72101203.splimit)
	c:RegisterEffect(e6)

	--gain def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_MATERIAL_CHECK)
	e7:SetValue(c72101203.valcheck)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SUMMON_COST)
	e8:SetOperation(c72101203.facechk)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)

	--quanbu shoubiao
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(72101203,2))
	e9:SetCategory(CATEGORY_POSITION)
	e9:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(c72101203.sbtg)
	e9:SetOperation(c72101203.sbop)
	c:RegisterEffect(e9)

	--zhishiwu shoubiao
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SET_POSITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e10:SetCondition(c72101203.zswcon)
	e10:SetTarget(c72101203.bsbtg)
	e10:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e10)
	--zhishiwu xiaoguo wuxiao
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e11:SetCondition(c72101203.zswcon)
	e11:SetTarget(c72101203.bwxtg)
	c:RegisterEffect(e11)
	--zhishiwu xiaoguo bunengfadong
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCode(EFFECT_CANNOT_ACTIVATE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(1,1)
	e12:SetValue(c72101203.bnfdval)
	c:RegisterEffect(e12)

	--changdi zhaohuan bubei wuxiao
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetValue(c72101203.cdval)
	c:RegisterEffect(e13)
	--changdi zhaohuan buneng fadong
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_SUMMON_SUCCESS)
	e14:SetCondition(c72101203.cdcon)
	e14:SetOperation(c72101203.cdop)
	c:RegisterEffect(e14)

end

--Summon rule
function c72101203.tzcon(e,c,minc)
	if c==nil then return true 
	end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c72101203.tzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c72101203.setcon(e,c,minc)
	if not c then return true 
	end
	return false
end

--wei quankang
function c72101203.qkval(e,te)
	local c=te:GetOwner()
	return not (c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()==ATTRIBUTE_DIVINE)
end

--fang zhishiwu
	--1
function c72101203.fzocon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,72101207)
end
function c72101203.fztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(IsCanAddCounter,tp,nil,LOCATION_MZONE,nil,0x7210,1)
	if chk==0 then return g:GetCount()>0		 
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c72101203.fzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(IsCanAddCounter,tp,nil,LOCATION_MZONE,nil,0x7210,1)
	local tc=g:GetFirst()
	while tc do
		tc:EnableCounterPermit(0x7210)
		tc:AddCounter(0x7210,1)
		tc=g:GetNext()
	end
end
	--2
function c72101203.fzmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and Duel.GetTurnPlayer()==tp
end
	--3
function c72101203.fzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c72101203.fzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and not (Duel.GetTurnPlayer()==tp)
end

--cannot special summon
function c72101203.splimit(e,se,sp,st)
	return Duel.IsPlayerAffectedByEffect(sp,72101203) and st&SUMMON_VALUE_MONSTER_REBORN>0
		and e:GetHandler():IsControler(sp) and e:GetHandler():IsLocation(LOCATION_GRAVE)
end

--gain def
function c72101203.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local def=0
	while tc do
		def=def+math.max(tc:GetTextDefense(),0)
		tc=g:GetNext()
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		--atk continuous effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function c72101203.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end

--quanbu shoubiao
function c72101203.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c72101203.sbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101203.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c72101203.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c72101203.sbop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72101203.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end

--zhishiwu shoubiao
function c72101203.zswcon(e)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c72101203.bsbtg(e,c)
	return c:GetCounter(0x7210)~=0 and not (c:GetOriginalAttribute()==ATTRIBUTE_DIVINE)
end
--zhishiwu xiaoguo wuxiao
function c72101203.bwxtg(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:GetCounter(0x7210)~=0 and not (c:GetOriginalAttribute()==ATTRIBUTE_DIVINE)
end
--zhishiwu xiaoguo bunengfadong
function c72101203.bnfdval(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:GetCounter(0x7210)~=0 and not (c:GetOriginalAttribute()==ATTRIBUTE_DIVINE)
end

--changdi zhaohuan bubei wuxiao
function c72101203.cdval(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end

--changdi zhaohuan chenggong bufadong
function c72101203.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
function c72101203.genchainlm(c)
	return  function (e,rp,tp)
				return e:GetHandler():IsSetCard(0xcea)
			end
end
function c72101203.cdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c72101203.genchainlm(e:GetHandler()))
end
