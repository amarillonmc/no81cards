--无边幻梦之王 神阶弗罗金
function c75075625.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c75075625.filter0,3,127,true)
	-- 特召条件
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c75075625.con0)
	e1:SetTarget(c75075625.tg0)
	e1:SetOperation(c75075625.op0)
	c:RegisterEffect(e1)
	-- 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075625,0))
	e2:SetCategory(CATEGORY_TOFIELD)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75075625)
	e2:SetTarget(c75075625.tg1)
	e2:SetOperation(c75075625.op1)
	c:RegisterEffect(e2)
	-- 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75075625,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c75075625.con2)
	e3:SetTarget(c75075625.tg2)
	e3:SetOperation(c75075625.op2)
	c:RegisterEffect(e3)
	-- 3
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75075625,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,75075626)
	e4:SetTarget(c75075625.tg3)
	e4:SetOperation(c75075625.op3)
	c:RegisterEffect(e4)
end
-- 融合
function c75075625.filter0(c,fc)
	return c:IsFusionSetCard(0x5754)
end
-- 特召程序
function c75075625.fdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD) and c:IsAbleToGraveAsCost()
end
function c75075625.wnfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsSetCard(0x5754) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c75075625.con0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c75075625.fdfilter,tp,LOCATION_SZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c75075625.wnfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and g1:GetCount()>0 and g2:GetCount()>0
end
function c75075625.tg0(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(c75075625.fdfilter,tp,LOCATION_SZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c75075625.wnfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	sg1:KeepAlive()
	e:SetLabelObject(sg1)
	return true
end
function c75075625.op0(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
-- 1
function c75075625.ffilter1(c)
	return c:IsSetCard(0x5754) and c:IsType(TYPE_FIELD)
end
function c75075625.chkgroup1(g)
	if g:GetCount()~=2 then return false end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return tc1:IsCode(tc2:GetCode())
end
function c75075625.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c75075625.ffilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return g:CheckSubGroup(c75075625.chkgroup1,2,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOFIELD,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75075625.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75075625.ffilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=g:SelectSubGroup(tp,c75075625.chkgroup1,false,2,2)
	if sg and sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.MoveToField(tc1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		Duel.MoveToField(tc2,tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
-- 2
function c75075625.leavefilter(c)
	return c:IsPreviousLocation(LOCATION_FZONE)
end
function c75075625.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75075625.leavefilter,1,nil)
end
function c75075625.spfilter2(c,e,tp)
	return c:IsSetCard(0x5754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75075625.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75075625.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c75075625.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75075625.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 3
function c75075625.gfilter(c)
	return c:IsType(TYPE_FIELD)
end
function c75075625.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c75075625.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c75075625.gfilter,tp,LOCATION_GRAVE,0,nil)
	local val=ct*400
	if val<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.Recover(tp,math.floor(val/2),REASON_EFFECT)
end
