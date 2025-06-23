-- 龗龘融合怪兽
local s,id=GetID()

function s.initial_effect(c)
	-- 融合怪兽特性
	c:EnableReviveLimit()
	
	-- 融合召唤方式1：常规融合
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsSetCard,0x5450),2,2)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(102380,0))
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_SPSUMMON_PROC)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetRange(LOCATION_EXTRA)
	e11:SetCondition(s.spcon)
	e11:SetTarget(s.sptg)
	e11:SetOperation(s.spop)
	c:RegisterEffect(e11)
		local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	-- 效果①：融合召唤成功时转化怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.tfcon)
	e2:SetTarget(s.tftg)
	e2:SetOperation(s.tfop)
	c:RegisterEffect(e2)
	
	-- 效果②：对方主要阶段处理+抽卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_RELEASE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+2)
	e3:SetCondition(s.opcon)
	e3:SetTarget(s.optg)
	e3:SetOperation(s.opop)
	c:RegisterEffect(e3)
	
	-- 效果③：保护场上的龗龘卡
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.rllimit)
	e3:SetValue(s.sumlimit)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(s.fuslimit)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
end
function s.sumlimit(e,c)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer())
end
function s.fuslimit(e,c,sumtype)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer()) and sumtype==SUMMON_TYPE_FUSION
end
function s.rllimit(e,c)
	return c:IsSetCard(0x5450) 
end
function s.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0 
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function s.fit11(c,sc)
	return c:IsReleasable() and not c:IsType(TYPE_FUSION) and c:IsSetCard(0x5450) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.fit11,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	return rg:CheckSubGroup(s.fselect,2,2,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(s.fit11,tp,LOCATION_MZONE,0,nil,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,s.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
-- 特殊召唤方式2：解放2只龗龘效果怪兽
function s.spfilter(c)
	return c:IsSetCard(0x5450) and c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsReleasable()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Release(g,REASON_COST)
end


-- 效果①条件：融合召唤成功
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

-- 效果①目标：选择场上/墓地1只怪兽
function s.tffilter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE))
end
function s.filter(c,tp,ft)
	if c:IsFacedown() then return false end
	local p=c:GetOwner()
	if p~=tp then ft=0 end
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(p) then
		if not c:IsAbleToChangeControler() then return false end
		r=LOCATION_REASON_CONTROL
	end
	return Duel.GetLocationCount(p,LOCATION_SZONE,tp,r)>ft
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,tp,0) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tffilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
end

-- 效果①操作：转化为永续魔法
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		Duel.MoveToField(tc,tc:GetControler(),tc:GetControler(),LOCATION_SZONE,POS_FACEUP,true)
	end
end

-- 效果②条件：对方主要阶段
function s.opcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end

-- 效果②目标：选择手卡/场上1张卡

function s.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- 效果②操作：处理4种方式+抽卡
function s.opop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.opfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local   op=aux.SelectFromOptions(tp,
		{aux.TRUE,aux.Stringid(id,3)},{tc:IsAbleToGrave(),aux.Stringid(id,4)},{tc:IsAbleToRemove(),aux.Stringid(id,5)},{tc:IsReleasableByEffect(),aux.Stringid(id,6)})	 
		if op==1 then
			Duel.Destroy(tc,REASON_EFFECT)
		elseif op==2 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		elseif op==3 then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		elseif op==4 then
			Duel.Release(tc,REASON_EFFECT)
		end	   
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

-- 效果③限制：不能被对方解放/作为素材

