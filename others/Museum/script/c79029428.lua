--个人行动-破境
function c79029428.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029428,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029428)
	e1:SetOperation(c79029428.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c79029428.handcon)
	c:RegisterEffect(e2)
	--change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c79029428.damcon1)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029428,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,09029428)
	e3:SetTarget(c79029428.sptg)
	e3:SetOperation(c79029428.spop)
	c:RegisterEffect(e3)
		if not c79029428.global_check then
		c79029428.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(c79029428.checkop)
		Duel.RegisterEffect(ge1,0)
end 
end
function c79029428.checkop(e,tp,eg,ep,ev,re,r,rp)
	local xp=re:GetHandlerPlayer()
	local flag=Duel.GetFlagEffectLabel(xp,79029428)
	if flag then
	Duel.SetFlagEffectLabel(xp,79029428,flag+1)
	else
	Duel.RegisterFlagEffect(xp,79029428,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c79029428.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local x=Duel.GetFlagEffectLabel(tp,79029428)	  
	if x==nil then return end
	Debug.Message("小僧的刀，只斩恶人！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029428,4))
	if Duel.SelectYesNo(tp,aux.Stringid(79029428,0)) then
	Debug.Message("斩却烦恼！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029428,5))
	Duel.Damage(1-tp,x*1000,REASON_EFFECT)
	end
end
function c79029428.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c79029428.damcon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c79029428.spfil(c,e,tp)
	return c:IsSetCard(0xa903) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c79029428.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetReasonPlayer()==1-tp and (Duel.IsExistingMatchingCard(c79029428.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) or (Duel.IsExistingMatchingCard(c79029428.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c79029428.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g1=Duel.GetMatchingGroup(c79029428.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c79029428.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)  
	if Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)>=Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil) then 
	if g1:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g1:Select(tp,1,1,nil)
	else 
	if g2:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g2:Select(tp,1,1,nil)
	end
	Debug.Message("油炸豆腐！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029428,6))
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c79029428.incon)
	e1:SetOperation(c79029428.inop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029428.incon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp 
end
function c79029428.inop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(79029428,3)) then 
	Debug.Message("六根清净！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029428,7))
	re:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e:Reset()
	end
end







