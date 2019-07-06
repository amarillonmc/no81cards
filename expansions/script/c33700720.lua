--铁虹的斥候
--Scrpited by Real_Scl
--saviorchaoslucifer@gmail.com
--15161685390@163.com
--Tencent QQ: 2798419987
local m=33700720
local cm=_G["c"..m]
if not RSNEONSVAL then
	RSNEONSVAL=RSNEONSVAL or {}
	rsneov=RSNEONSVAL
	rsneov.LPTbl={[0]=0,[1]=0,[2]=0,[3]=0}
	rsneov.LPTbl2={[0]=0,[1]=0}
function rsneov.TunerFun(c,lp)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetLabel(lp)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetCost(rsneov.LPcost)
	e1:SetOperation(rsneov.tunerop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function rsneov.LPcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,e:GetLabel()) end
	Duel.PayLPCost(tp,e:GetLabel())
end
function rsneov.tunerop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(TYPE_TUNER)
	c:RegisterEffect(e1)
end
function rsneov.LPChangeFun(c)
	if Duel.GetFlagEffect(0,m)>0 then return end
	Duel.RegisterFlagEffect(0,m,0,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetOperation(rsneov.LPcheckop)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetValue(rsneov.LPcheckop2)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e3:SetOperation(rsneov.Lpclear)
	Duel.RegisterEffect(e3,0)
end
function rsneov.LPcheckop(e,tp,eg,ep,ev,re,r,rp)
	rsneov.LPTbl[ep]=rsneov.LPTbl[ep]+ev
	local rc=re:GetHandler()
	if rc:IsSetCard(0x44e) then
		rsneov.LPTbl[ep+2]=rsneov.LPTbl[ep+2]+ev
	end
end
function rsneov.LPcheckop2(e,tp,eg,ep,ev,re,r,rp)
	rsneov.LPTbl2[ep]=rsneov.LPTbl2[ep]+ev
end
function rsneov.Lpclear(e,tp,eg,ep,ev,re,r,rp)
	rsneov.LPTbl={[0]=0,[1]=0,[2]=0,[3]=0}
	rsneov.LPTbl2={[0]=0,[1]=0}
end
function rsneov.RDTurnFun(c,cate,pro,lp,tg,op,notquick)
	local code=c:GetOriginalCode()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	if cate then
		e1:SetCategory(cate)
	end
	if pro then
		e1:SetProperty(pro)
	end
	local etype=notquick and EFFECT_TYPE_IGNITION or EFFECT_TYPE_QUICK_O 
	e1:SetType(etype)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,code+100)
	if etype==EFFECT_TYPE_QUICK_O then
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	end
	e1:SetLabel(lp)
	e1:SetCost(rsneov.LPcost)
	e1:SetCondition(function(e,tp) return rsneov.LPTbl[tp]+rsneov.LPTbl2[tp]>0 end)
	if tg then
		e1:SetTarget(tg)
	end
	if op then
		e1:SetOperation(op)
	end
	c:RegisterEffect(e1)
end
function rsneov.LPCon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function rsneov.LPCon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function rsneov.ToGraveCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end

end
----------------------------------
if cm then
function cm.initial_effect(c)
	rsneov.TunerFun(c,900)
	rsneov.RDTurnFun(c,CATEGORY_SPECIAL_SUMMON,nil,500,cm.tg,cm.op)
	rsneov.LPChangeFun(c)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x44e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

end
