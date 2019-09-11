--迷途竹林
function c11200028.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200028+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c11200028.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(c11200028.val2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11200028.tg3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--
	if not c11200028.global_check then
		c11200028.global_check=true
		c11200028[0]=0
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(c11200028.clear)
		Duel.RegisterEffect(ge0,0)
	end
--
end
--
c11200028.xig_ihs_0x132=1
c11200028.xig_ihs_0x133=1
--
function c11200028.clear(e,tp,eg,ep,ev,re,r,rp)
	c11200028[0]=0
end
--
function c11200028.ofilter1(c)
	return c:IsFusionSummonableCard() and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11200028.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11200028.ofilter1,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(11200028)==0 then
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetDescription(aux.Stringid(11200028,0))
			e1_1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1_1:SetType(EFFECT_TYPE_FIELD)
			e1_1:SetCode(EFFECT_SPSUMMON_PROC)
			e1_1:SetRange(LOCATION_EXTRA)
			e1_1:SetValue(SUMMON_TYPE_FUSION)
			e1_1:SetReset(RESET_PHASE+PHASE_END)
			e1_1:SetCondition(c11200028.con1_1)
			e1_1:SetOperation(c11200028.op1_1)
			tc:RegisterEffect(e1_1)
			tc:RegisterFlagEffect(11200028,RESET_PHASE+PHASE_END,0,0)
		end
		tc=g:GetNext()
	end 
	c11200028[0]=c11200028[0]+1
end
--
function c11200028.cfilter1_1(c,fc)
	return c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and c:IsType(TYPE_MONSTER)
end
function c11200028.con1_1(e,c)
	if c11200028[0]==0 then return false end
	if c==nil then return true end
	local tp=c:GetControler()
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c11200028.cfilter1_1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	return c:CheckFusionMaterial(mg,nil,chkf)
end
function c11200028.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c11200028.cfilter1_1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local mat=Duel.SelectFusionMaterial(tp,c,mg,nil,chkf)
	c:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_FUSION+REASON_COST+REASON_MATERIAL)
	local e1_1_1=Effect.CreateEffect(c)
	e1_1_1:SetDescription(aux.Stringid(11200028,1))
	e1_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1_1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1_1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1_1_1:SetReset(RESET_EVENT+0xfe0000)
	c:RegisterEffect(e1_1_1,true)
	c11200028[0]=c11200028[0]-1
end
--
function c11200028.val2(e,c)
	return c:IsFaceup() and (c.xig_ihs_0x132 or c:IsCode(11200019) or c:IsSetCard(0x621))
end
--
function c11200028.tg3(e,c)
	return c:IsFaceup() and (c.xig_ihs_0x132 or c:IsCode(11200019) or c:IsSetCard(0x621))
end
--