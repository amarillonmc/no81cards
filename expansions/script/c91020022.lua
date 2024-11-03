--真神使者 幽冥貔貅
local m=91020022
local cm=c91020022
function c91020022.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m*3)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,m*2)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function cm.cfilter(c,tp,f)
	return f(c) and Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x9d1)
end
function cm.con1(e,c)
if c==nil then return true end  
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,Card.IsReleasable)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
   local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp,Card.IsReleasable)
	Duel.Release(g,REASON_COST)
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x9d0) and c:IsLocation(LOCATION_EXTRA)
end
--e2
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetReasonCard():IsSetCard(0x9d0) 
end
--e2
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(91020022,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,91020022)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.tgf)
	e6:SetOperation(cm.opf)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e6,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  re:GetHandler()==e:GetHandler() and Duel.GetFlagEffect(tp,39185163)==0
end
function cm.tgf(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(m,0)},
			{true,aux.Stringid(m,1)})
	if op==1 then 
	local tg=re:GetTarget() 
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	Duel.RegisterFlagEffect(e:GetHandler(),91020022,RESET_PHASE+PHASE_END,0,1)  end
end
function cm.opf(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(c,91020022)>0  then
	 local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
	elseif Duel.GetFlagEffect(c,91020022)==0  then
	  local code=c:GetOriginalCode()
		local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0,nil,code)
		local op=re:GetOperation()
		for hc in aux.Next(g) do
			local pro1,pro2=re:GetProperty()
			local e1=re:Clone()
			e1:SetProperty(pro1|EFFECT_FLAG_SET_AVAILABLE,pro2)
			e1:SetCountLimit(1,code+321+EFFECT_COUNT_CODE_OATH)
			e1:SetOperation(function(ce,ctp,ceg,cep,cev,cre,cr,crp)
							op(ce,ctp,ceg,cep,cev,cre,cr,crp) 
							e1:Reset()
							end)
			hc:RegisterEffect(e1)
		end
	end
end
--e5
function cm.fit5(c,e,tp)
return  c:IsCanBeSpecialSummoned(e,0,tp,false,false)and c:IsSetCard(0x9d1) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.fit5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cg=Duel.GetMatchingGroup(cm.fit5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if cg:GetCount()>0 then 
	local tc=Duel.SelectMatchingCard(tp,cm.fit5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)   
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end