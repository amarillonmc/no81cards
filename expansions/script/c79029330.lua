--黑钢国际·行动-目标搜寻
function c79029330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c79029330.ztg)
	e1:SetOperation(c79029330.zop)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,79029330)
	e2:SetTarget(c79029330.target)
	e2:SetOperation(c79029330.activate)
	c:RegisterEffect(e2)
end
function c79029330.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	local seq=math.log(bit.rshift(dis,16),2)
	e:SetLabel(seq)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c79029330.zop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029330.spcon)
	e1:SetOperation(c79029330.spop)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
end
function c79029330.fil(c,seq)
	return c:GetSequence()==seq  
end
function c79029330.xspfil(c,tc,e,tp)
	return c:GetAttribute()==tc:GetAttribute() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029330.spcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	if not eg:IsExists(c79029330.fil,1,nil,seq) then return end 
	local tc=eg:GetFirst()
	return eg:IsExists(c79029330.fil,1,nil,seq) and Duel.IsExistingMatchingCard(c79029330.xspfil,tp,LOCATION_EXTRA,0,1,nil,tc,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rp~=tp
end
function c79029330.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029330)
	if Duel.SelectYesNo(tp,aux.Stringid(79029330,0)) then
	local tc=eg:GetFirst()
	local xc=Duel.SelectMatchingCard(tp,c79029330.xspfil,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp):GetFirst()
	Duel.SpecialSummon(xc,0,tp,tp,false,false,POS_FACEUP)
	e:Reset()
	end
end  
function c79029330.chfil(c)
	return not c:IsSetCard(0xa900)
end
function c79029330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local x1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local x2=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,x2-x1) and x1>0 and x1<x2 and not Duel.IsExistingMatchingCard(c79029330.chfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x2-x1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x2-x1)
end
function c79029330.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end














